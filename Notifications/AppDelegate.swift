//
//  AppDelegate.swift
//  Notifications
//
//  Created by Alexey Efimov on 21.06.2018.
//  Copyright © 2018 Alexey Efimov. All rights reserved.
//

import UIKit
import UserNotifications



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var delegate: TableViewController?
    
    let notificationCenter = UNUserNotificationCenter.current()
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        requestAutorization()
        notificationCenter.delegate = self
        print(#function, #line)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        print(#function, #line)
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print(#function, #line)
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print(#function, #line)
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print(#function, #line)
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print(#function, #line)
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //NOTIFICATION CENTER METHODS

    func requestAutorization() {
        print(#function, #line)
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            
            print("Permission granted: \(granted)")
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        print(#function, #line)
        notificationCenter.getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
        }
    }
    
    func scheduelNotification(notificationType: String) {
        print(#function, #line)
        
        let content = UNMutableNotificationContent()
        let userAction = "User Action"
        
        content.title = notificationType
        content.body = "This is example how to create \(notificationType)"
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = userAction
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let identifire = "Local notification"
        let request = UNNotificationRequest(identifier: identifire,
                                            content: content,
                                            trigger: trigger)
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
        }
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        let deleteAction = UNNotificationAction(identifier: "Delete", title: "Delete", options: [.destructive])
        let BuyAction = UNNotificationAction(identifier: "Buy", title: "Buy", options: [])
        let sellAction = UNNotificationAction(identifier: "Sell", title: "Sell", options: [])
        let category = UNNotificationCategory(
            identifier: userAction,
            actions: [snoozeAction, deleteAction, BuyAction, sellAction],
            intentIdentifiers: [],
            options: [])
        notificationCenter.setNotificationCategories([category])
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        print(#function, #line)
        
        completionHandler([.alert, .sound])
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print(#function, #line)
        
        if response.notification.request.identifier == "Local notification" {
            print("Handling notification with the local notification identifire")
        }
        
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Default")
            delegate?.view.backgroundColor = .green
            print(delegate)
            delegate?.goTo()
        case "Snooze":
            print("Snooze")
            scheduelNotification(notificationType: "Reminder")
        case "Delete":
            print("Delete")
        case "Buy":
            print("Buy")
            delegate?.goTo()
        case "Sell":
            print ("Sell")
        default:
            print(response.actionIdentifier)
        }
        
        completionHandler()
        
    }
}

