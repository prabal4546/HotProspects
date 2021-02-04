//
//  ContentView.swift
//  HotProspects
//
//  Created by PRABALJIT WALIA     on 02/02/21.
//

import SwiftUI
import UserNotifications
struct ContentView: View {
    @State private var selectedTab = 0
    var body: some View {
        Text("Hello, World!")
        VStack {
            Button("Request Permission") {
                // first
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {success,error in
                    if success {
                          print("All set!")
                      } else if let error = error {
                          print(error.localizedDescription)
                      }

                })
            }

            Button("Schedule Notification") {
                // second
                let content = UNMutableNotificationContent()
                content.title = "Feed the cat"
                content.subtitle = "It looks hungry"
                content.sound = UNNotificationSound.default

                // show this notification five seconds from now
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

                // choose a random identifier
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                // add our notification request
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
