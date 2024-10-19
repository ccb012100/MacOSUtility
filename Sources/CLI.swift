import AppKit
import ArgumentParser
import CoreGraphics
import Foundation
import Logging

@main
struct CLI: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A utility for interacting with macOS via the terminal.",

        subcommands: [Toggle.self],
        // A default subcommand, when provided, is automatically selected if a
        // subcommand is not given on the command line.
        defaultSubcommand: Toggle.self)
}

struct Options: ParsableArguments {
    @Flag(help: "Print debug information to stdout")
    var verbose = false
}

extension CLI {
    struct Toggle: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract:
                "Toggle an application (hide it if it's active; otherwise launch/activate it)."
        )

        @Argument(help: "The Application to toggle.")
        var application: String

        @Option(help: "The process name the Application runs under.")
        var process: String? = nil

        @OptionGroup var options: Options

        mutating func run() throws {
            print(
                "application: String{ \(application) } options: Bool{ verbose: Bool{ \(options.verbose) } }"
            )

            var logger: Logger = Logger(label: "ccb012100.MacOSUtility.CLI")
            if options.verbose { logger.logLevel = .debug }

            switchToApp(named: application, process: process, logger: logger)
        }
    }
}

/// Toggle an Application by name
///
/// - If the Application is the active Application, hide it.
/// - If the Application is running but not the active Application, activate it.
/// - If the Application is not running, launch it.
///
/// - Remark: [source](https://stackoverflow.com/a/47264136)
func switchToApp(
    named appName: String, process processName: String? = nil, logger: Logger, dryRun: Bool = false
) {
    let options = CGWindowListOption(
        arrayLiteral: CGWindowListOption.excludeDesktopElements,
        CGWindowListOption.optionOnScreenOnly)

    guard
        let windowInfoList = CGWindowListCopyWindowInfo(options, CGWindowID(0)) as NSArray?
            as? [[String: AnyObject]]
    else {
        renderNotification(message: "Unable to convert windowListInfo to array", isError: true)
        return
    }
    logger.debug("Foo")

    if let window = windowInfoList.first(where: {
        ($0["kCGWindowOwnerName"] as? String)?.contains(processName ?? appName) ?? false
    }), let pid = window["kCGWindowOwnerPID"] as? Int32 {  // application is running; get its pid
        let app = NSRunningApplication(processIdentifier: pid)

        if app == nil {  // failed to get app by pid
            let errorMsg = "Unable to get application with pid \"\(pid)\"!"
            logger.error("\(errorMsg)")
            renderNotification(message: errorMsg, isError: true)
        } else {
            logger.debug("App '\(appName)' is running.")

            if app!.isActive {  // app is the Active application
                logger.debug("'\(appName)' is active. Attempting to hide it...")
                app?.hide()
            } else if !app!.activate(options: .activateIgnoringOtherApps) {  // try to activate the application
                let errorMsg = "Failed to activate '\(appName)'."
                logger.error("\(errorMsg)")
                renderNotification(message: errorMsg, isError: true)
            }
        }
    } else {
        logger.debug("App '\(appName)' is not running. Attempting to launch it...")
        if !NSWorkspace.shared.launchApplication(appName) {  // try to launch the application
            // TODO: launchApplication is deprecated
            let errorMsg = "Unable to launch application \"\(appName)\"!"
            logger.error("\(errorMsg)")
            renderNotification(message: errorMsg, isError: true)
        }
    }
}

/// Trigger a persistent System Notification
///
/// - Parameters
///     - message: The Notification's body
///     - isError:
///         - `true` if the notification is an error message;
///         - `false` if the message is solely informational
func renderNotification(message: String, isError: Bool) {
    // display for 5 seconds
    let elements: [CFString: NSObject] = [
        kCFUserNotificationAlertTopMostKey: 1 as NSNumber,
        kCFUserNotificationAlertHeaderKey: "MacOSUtility\( isError ? " Error" : "")" as NSString,  // title
        kCFUserNotificationAlertMessageKey: message as NSString,
    ]

    var error: Int32 = 0
    CFUserNotificationCreate(
        nil,
        0,
        isError ? kCFUserNotificationCautionAlertLevel : kCFUserNotificationPlainAlertLevel, &error,
        elements as CFDictionary)

    if error != 0 { fatalError("Unable to display notification dialog") }
}
