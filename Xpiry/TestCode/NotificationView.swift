//
//  NotificationView.swift
//  Xpiry
//
//  Created by Jason Kenneth on 17/01/23.
//

import SwiftUI

struct NotificationView: View {
    var body: some View {
        VStack {
            Button("Request Permission") {
                notifRequest()
            }
            
            Button("Schedule Notification") {
                scheduleNotif()
            }
        }
        
    }
    
    func notifRequest() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func scheduleNotif() {
        let content = UNMutableNotificationContent()
        content.title = "Feed the cat"
        content.subtitle = "It looks hungry"
        content.sound = .default
        
        //time notification
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
        
//        //calendar notification
//        var dateComponents = DateComponents()
//        dateComponents.hour = 20
//
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
