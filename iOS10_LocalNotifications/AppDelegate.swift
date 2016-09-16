//
//  AppDelegate.swift
//  iOS10_LocalNotifications
//
//  Created by Andrew Erickson on 2016-09-14.
//  Copyright © 2016 Robots and Pencils. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = NotificationManager.sharedInstance
        }
        
        return true
    }

    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        // Handle local notification with alert or alternative UI
    }
}

