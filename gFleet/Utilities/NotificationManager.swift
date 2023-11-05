//
//  NotificationManager.swift
//  gFleet
//
//  Created by Eric Rodriguez on 9/29/23.
//

import Foundation
import UserNotifications

enum ButtonType: String {
    case fix
}

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let instance = NotificationManager()
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print("Error: \(error)")
            } else {
                print("success")
            }
        }
    }
    func sendNotification(title: String, subtitle: String, sound: UNNotificationSound = .default) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.sound = sound
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    func sendButtonNotification(title: String, subtitle: String, button: ButtonType = .fix) {
        let fixAction = UNNotificationAction(identifier: "\(button.rawValue.uppercased())_IDENTIFIER", title: button.rawValue.capitalized, options: .foreground)
           
        let category = UNNotificationCategory(identifier: "CATEGORY_IDENTIFIER", actions: [fixAction], intentIdentifiers: [], options: [.customDismissAction])
           
        UNUserNotificationCenter.current().setNotificationCategories([category])
           
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.categoryIdentifier = "CATEGORY_IDENTIFIER"
        content.sound = .default
        content.badge = 1
           
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
            case UNNotificationDismissActionIdentifier:
               print("notification dismissed by user")
               break
            case "FIX_IDENTIFIER":
                print("fix button clicked")
            default:
                break
        }
        completionHandler()
    } 
}
