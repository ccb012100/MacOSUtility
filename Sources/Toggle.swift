import AppKit
import Logging

/// Toggle an Application by its Bundle ID
///
/// - If the Application is the active Application, hide it.
/// - If the Application is running but not the active Application, bring it to the front.
/// - If the Application is not running, launch it.
func toggleApp(withBundleId bundleId: String, withLogger logger: Logger) {
    let app = NSWorkspace.shared.runningApplications.first { $0.bundleIdentifier == bundleId }

    if app != nil {
        // app is running
        if app!.isActive {
            app!.hide()
            // TODO: for some reason, app.hide() always returns false
            // if !app!.hide() {
            //     logErrorAndNotify(
            //         logger,
            //         withMessage: "Unable to hide app with Bundle Id \"\(bundleId)\"!")
            // }
        } else {
            app!.activate()
            if !app!.activate() {
                logErrorAndNotify(
                    logger,
                    withMessage: "Unable to activate app with Bundle Id \"\(bundleId)\"!")
            }
        }
    } else {
        // app is not running
        guard let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleId)
        else {
            logErrorAndNotify(
                logger,
                withMessage: "Unable to get application URL for Bundle Id \"\(bundleId)\"!")
            return
        }

        NSWorkspace.shared.openApplication(
            at: appURL, configuration: NSWorkspace.OpenConfiguration())
    }
}
