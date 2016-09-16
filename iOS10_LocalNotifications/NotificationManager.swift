//
//  NotificationManager.swift
//  iOS10_LocalNotifications
//
//  Created by Andrew Erickson on 2016-09-14.
//  Copyright © 2016 Robots and Pencils. All rights reserved.
//

import Foundation
import UserNotifications
import CoreLocation
import UIKit

class NotificationManager: NSObject {
    
    static let sharedInstance = NotificationManager()
    
    //MARK: Public
    
    class func scheduleNotification(id: String, title: String, subtitle: String, body: String, badgeCount: NSNumber?, userInfo: [AnyHashable: Any] = [:]) {
        
        if #available(iOS 10.0, *) {
            scheduleUNUserNotification(id: id, title: title, subtitle: subtitle, body: body, badgeCount: badgeCount, userInfo: userInfo)
        } else {
            scheduleUILocalNotification(body: body)
        }
    }
    
    @available(iOS 10.0, *)
    class func requestAuthorization(completion: ((_ granted: Bool)->())? = nil) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in
            if granted {
                completion?(true)
            } else {
                center.getNotificationSettings(completionHandler: { settings in
                    if settings.authorizationStatus != .authorized {
                        //User has not authorized notifications
                    }
                    if settings.lockScreenSetting != .enabled {
                        //User has either disabled notifications on the lock screen for this app or it is not supported
                    }
                    completion?(false)
                })
            }
        }
    }
    
    @available(iOS 10.0, *)
    class func pending(completion: @escaping (_ pendingCount: Int)->()) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            completion(requests.count)
        }
    }
    
    @available(iOS 10.0, *)
    class func delivered(completion: @escaping (_ deliveredCount: Int)->()) {
        UNUserNotificationCenter.current().getDeliveredNotifications { notifications in
            completion(notifications.count)
        }
    }
    
    @available(iOS 10.0, *)
    class func checkStatus() {
    }
    
    //MARK: Private
    
    @available(iOS 10.0, *)
    private class func scheduleUNUserNotification(id: String, title: String, subtitle: String, body: String, badgeCount: NSNumber?, userInfo: [AnyHashable: Any] = [:]) {
        requestAuthorization { granted in
            let content = createNotificationContent(title: title, subtitle: subtitle, body: body, badgeCount: badgeCount, userInfo: userInfo)
            let trigger = createTimeIntervalNotificationTrigger()
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                // Use this block to determine if the notification request was added successfully.
                if error == nil {
                    NSLog("Notification scheduled")
                } else {
                    NSLog("Error scheduling notification")
                }
            }
        }
    }
    
    @available(iOS 10.0, *)
    private class func createNotificationContent(title: String, subtitle: String, body: String, badgeCount: NSNumber?, userInfo: [AnyHashable: Any] = [:]) -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.sound = UNNotificationSound.default()
        content.badge = badgeCount
        content.userInfo = userInfo
        content.attachments = createSampleAttachments()
        
        return content
    }
    
    //MARK: iOS 9 UILocalNotification support
    
    private class func scheduleUILocalNotification(body: String) {
        let localNotification = UILocalNotification()
        localNotification.fireDate = Date().addingTimeInterval(20)
        localNotification.alertBody = body
        localNotification.timeZone = TimeZone.current
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }
    
    //MARK: Sample triggers
    
    @available(iOS 10.0, *)
    private class func createTimeIntervalNotificationTrigger() -> UNTimeIntervalNotificationTrigger {
        return UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
    }
    
    @available(iOS 10.0, *)
    private class func createCalendarNotificationTrigger() -> UNCalendarNotificationTrigger {
        var dateComponents = DateComponents()
        dateComponents.hour = 4
        dateComponents.minute = 45
        return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    }
    
    @available(iOS 10.0, *)
    private class func createLocationNotificationTrigger() -> UNLocationNotificationTrigger {
        let winnipegOfficeRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 49.878510, longitude: -97.145480), radius: 10, identifier: "R&P Winnipeg")
        return UNLocationNotificationTrigger(region: winnipegOfficeRegion, repeats: false)
    }
    
    //MARK: Sample attachment
    
    @available(iOS 10.0, *)
    private class func createSampleAttachments() -> [UNNotificationAttachment] {
        if let urlPath = Bundle.main.path(forResource: "pikachu", ofType: "png") {
            let attachmentURL = NSURL.fileURL(withPath: urlPath)
            if let attachment = try? UNNotificationAttachment(identifier: "attachment", url: attachmentURL, options: nil) {
                return [attachment]
            }
        }
        
        return []
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        NSLog("User Notification Center did receive notification response")
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        NSLog("User Notification Center will present notification")
    }
}

