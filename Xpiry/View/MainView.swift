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
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color(red: 252/255, green: 250/255, blue: 250/255).opacity(0.25))
    }
    
    @State private var tabSelection = 0
   
    var body: some View {
        TabView(selection: $tabSelection) {
            AllItemsView().tabItem {
                if tabSelection == 0 {
                           Image("HouseIcon")
                       } else {
                           Image("HouseFadeIcon")
                       }
                       Text("All Items")
                    .font(Font.custom("DMSans-Medium", size: 18))
            }.tag(0)
            
            ShoppingListView().tabItem {
                if tabSelection == 1 {
                           Image("ListIcon")
                       } else {
                           Image("ListFadeIcon")
                       }
                       Text("Shopping List")
                    .font(Font.custom("DMSans-Medium", size: 18))
            }.tag(1)
            
            UsageReportView().tabItem {
                if tabSelection == 2 {
                           Image("PieIcon")
                       } else {
                           Image("PieFadeIcon")
                       }
                       Text("Product Usage")
                    .font(Font.custom("DMSans-Medium", size: 18))
            }.tag(2)
        }
        .background(Color(red: 252/255, green: 250/255, blue: 250/255))
        .preferredColorScheme(.light)
        .fullScreenCover(isPresented: $showStartUp, content: {
                StartUpView(showStartUp: $showStartUp)
            })
        .tint(Color(red: 252/255, green: 250/255, blue: 250/255))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
