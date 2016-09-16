//
//  UIViewController+Extension.swift
//  iOS10_LocalNotifications
//
//  Created by Andrew Erickson on 2016-09-14.
//  Copyright © 2016 Robots and Pencils. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Notifications", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
