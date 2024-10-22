import AppKit
import Logging

func logErrorAndNotify(_ logger: Logger, withMessage message: String) {
    logger.error("\(message)")
    renderNotification(message: message, showAsError: true)
}

/// Trigger a persistent System Notification
///
/// - Parameters
///     - message: The Notification's body
///     - isError:
///         - `true` if the notification is an error message;
///         - `false` if the message is solely informational
func renderNotification(message: String, showAsError: Bool) {
    // display for 5 seconds
    let elements: [CFString: NSObject] = [
        kCFUserNotificationAlertTopMostKey: 1 as NSNumber,
        kCFUserNotificationAlertHeaderKey: "MacOSUtility\( showAsError ? " Error" : "")"  // notification title
            as NSString,
        kCFUserNotificationAlertMessageKey: message as NSString,
    ]

    var error: Int32 = 0
    CFUserNotificationCreate(
        nil,
        0,
        showAsError ? kCFUserNotificationCautionAlertLevel : kCFUserNotificationPlainAlertLevel,
        &error,
        elements as CFDictionary)

    if error != 0 { fatalError("Unable to display notification dialog") }
}
