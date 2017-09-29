//
//  NotificationService.swift
//  XHWLPushExtension
//
//  Created by gongairong on 2017/9/28.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

//    APNs到来的时候会调用这个方法，此时你可以对推送过来的内容进行处理，然后使用contentHandler完成这次处理。但是如果时间太长了，APNs就会原样显示出来。 也就是说，我们可以在这个方法中处理我们的通知，个性化展示给用户。
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
            
            contentHandler(bestAttemptContent)
        }
    }
    
//     而第二个方法，是对第一个方法的补救。第二个方法会在过期之前进行回调，此时你可以对你的APNs消息进行一下紧急处理。
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
