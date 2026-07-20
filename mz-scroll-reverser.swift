import ApplicationServices
import CoreGraphics
import Foundation

// -- State directory & log ---------------------------------------------------
// Daemon writes its own log because open -a detaches stderr from the shell.

let stateDir    = "\(NSHomeDirectory())/.local/share/sr"
let pidFile     = "\(stateDir)/sr.pid"
let logFilePath = "\(stateDir)/sr.log"

func ensureStateDir() {
    try? FileManager.default.createDirectory(
        atPath: stateDir, withIntermediateDirectories: true)
}

func writeLog(_ message: String) {
    let line = message + "\n"
    guard let data = line.data(using: .utf8) else { return }
    if let fh = FileHandle(forWritingAtPath: logFilePath) {
        fh.seekToEndOfFile()
        fh.write(data)
        fh.closeFile()
    } else {
        try? data.write(to: URL(fileURLWithPath: logFilePath), options: .atomic)
    }
}

// -- PID file ----------------------------------------------------------------

func writePID() {
    try? "\(ProcessInfo.processInfo.processIdentifier)\n"
        .write(toFile: pidFile, atomically: true, encoding: .utf8)
}

func removePID() {
    try? FileManager.default.removeItem(atPath: pidFile)
}

// -- Signal handling ---------------------------------------------------------

signal(SIGTERM) { _ in removePID(); exit(0) }
signal(SIGINT)  { _ in removePID(); exit(0) }

// -- Accessibility permission ------------------------------------------------

func checkAccessibility() {
    let promptKey = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString
    let trusted   = AXIsProcessTrustedWithOptions([promptKey: true] as CFDictionary)
    if !trusted {
        // AXIsProcessTrustedWithOptions has opened System Settings and added
        // mz-scroll-reverser.app to the Accessibility list — user just flips the toggle.
        writeLog("mz-scroll-reverser: Accessibility permission required.")
        writeLog("Enable mz-scroll-reverser in System Settings → Privacy & Security → Accessibility, then run `sr` again.")
        exit(2)
    }
}

// -- Event tap ---------------------------------------------------------------

var eventTap: CFMachPort?

let callback: CGEventTapCallBack = { _, type, event, _ in
    // Re-enable the tap if macOS disables it (timeout, heavy input, wake).
    if type == .tapDisabledByTimeout || type == .tapDisabledByUserInput {
        if let tap = eventTap { CGEvent.tapEnable(tap: tap, enable: true) }
        return Unmanaged.passUnretained(event)
    }

    guard type == .scrollWheel else { return Unmanaged.passUnretained(event) }

    // scrollWheelEventIsContinuous: 0 = discrete mouse wheel,
    //                               non-zero = continuous trackpad.
    if event.getIntegerValueField(.scrollWheelEventIsContinuous) == 0 {
        let dy = event.getIntegerValueField(.scrollWheelEventDeltaAxis1)
        event.setIntegerValueField(.scrollWheelEventDeltaAxis1, value: -dy)
        let dx = event.getIntegerValueField(.scrollWheelEventDeltaAxis2)
        event.setIntegerValueField(.scrollWheelEventDeltaAxis2, value: -dx)
    }

    return Unmanaged.passUnretained(event)
}

// -- Main --------------------------------------------------------------------

ensureStateDir()
try? FileManager.default.removeItem(atPath: logFilePath)  // fresh log each run
checkAccessibility()

guard let tap = CGEvent.tapCreate(
    tap: .cghidEventTap,
    place: .tailAppendEventTap,
    options: .defaultTap,
    eventsOfInterest: CGEventMask(1 << CGEventType.scrollWheel.rawValue),
    callback: callback,
    userInfo: nil
) else {
    writeLog("mz-scroll-reverser: failed to create event tap.")
    writeLog("Grant Accessibility access in System Settings → Privacy & Security → Accessibility.")
    exit(1)
}

eventTap = tap

guard let source = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0) else {
    writeLog("mz-scroll-reverser: failed to create run-loop source.")
    exit(1)
}

writePID()

CFRunLoopAddSource(CFRunLoopGetCurrent(), source, .commonModes)
CGEvent.tapEnable(tap: tap, enable: true)
CFRunLoopRun()
