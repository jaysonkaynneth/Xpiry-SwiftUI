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
        .preferredColorScheme(.light)
        .fullScreenCover(isPresented: $showStartUp, content: {
                StartUpView(showStartUp: $showStartUp)
            })
        .tint(.white)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
