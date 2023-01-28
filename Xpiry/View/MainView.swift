//
//  MainView.swift
//  Xpiry
//
//  Created by Jason Kenneth on 08/01/23.
//

import SwiftUI

struct MainView: View {
    @AppStorage("showStartUp") var showStartUp: Bool = true
    
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray
    }
   
    var body: some View {
        TabView {
            AllItemsView().tabItem {
                Label("All Items", systemImage: "house")
            }
            
            ShoppingListView().tabItem {
                Label("Shopping List", systemImage: "list.bullet.rectangle.portrait")
            }
            
            UsageReportView().tabItem {
                Label("Usage Report", systemImage: "chart.pie")
            }
        }
        .onAppear(perform: notifRequest)
        .fullScreenCover(isPresented: $showStartUp, content: {
                StartUpView(showStartUp: $showStartUp)
            })
        .tint(.white)
    }
    
    func notifRequest() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Success")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
