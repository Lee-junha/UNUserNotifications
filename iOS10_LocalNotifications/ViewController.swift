//
//  ViewController.swift
//  iOS10_LocalNotifications
//
//  Created by Andrew Erickson on 2016-09-14.
//  Copyright © 2016 Robots and Pencils. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func scheduleNotificationAction(_ sender: AnyObject) {
        NotificationManager.scheduleNotification(id: "alert", title: "iOS Presentation", subtitle: "Friday September 16th", body: "Remember to finalize your presentation for tomorrow!", badgeCount: nil)
    }
    
    @IBAction func howManyScheduledAction(_ sender: AnyObject) {
        if #available(iOS 10.0, *) {
            NotificationManager.pending { [weak self] pendingCount in
                self?.showAlert(message: "\(pendingCount) pending notifications")
            }
        } else {
            showAlert(message: "Pending notifications are only available in iOS 10")
        }
    }
    
    @IBAction func howManyDeliveredAction(_ sender: AnyObject) {
        if #available(iOS 10.0, *) {
            NotificationManager.delivered { [weak self] deliveredCount in
                self?.showAlert(message: "\(deliveredCount) delivered notifications")
            }
        } else {
            showAlert(message: "Delivered notifications are only available in iOS 10")
        }
    }
}
