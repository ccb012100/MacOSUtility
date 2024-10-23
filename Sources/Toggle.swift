import AppKit
import Logging

/// Toggle an Application by its Bundle ID
///
/// - If the Application is the active Application, hide it.
/// - If the Application is running but not the active Application, bring it to the front.
/// - If the Application is not running, launch it.
func toggleApp(withBundleId bundleId: String, withLogger logger: Logger) {
    /* NOTE: I tried grabbing the frontmost application and checking it against the BundleId,
     *       thinking it would save time if the app we're toggling is active. It did, but only
     *       about ~3ms. However, the other scenario (when the app isn't active) increased
     *       ~10ms, so it was not worth the tradeoff.
     */
    let app = NSWorkspace.shared.runningApplications.first { $0.bundleIdentifier == bundleId }

    if app != nil {  // app is running
        if app!.isActive {
            app!.hide()
            // TODO: for some reason, app.hide() always returns false
            // if !app!.hide() {
            //     logErrorAndNotify(
            //         logger,
            //         withMessage: "Unable to hide app with Bundle Id \"\(bundleId)\"!")
            // }
            return
        }

        if !app!.activate() {
            logErrorAndNotify(
                logger, withMessage: "Unable to activate app with Bundle Id \"\(bundleId)\"!")
        }
    }

    // app is not running
    guard let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleId)
    else {
        logErrorAndNotify(
            logger, withMessage: "Unable to get application URL for Bundle Id \"\(bundleId)\"!")
        return
    }

    NSWorkspace.shared.openApplication(at: appURL, configuration: NSWorkspace.OpenConfiguration())
}
