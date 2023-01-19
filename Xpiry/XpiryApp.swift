//
//  XpiryApp.swift
//  Xpiry
//
//  Created by Jason Kenneth on 29/11/22.
//

import SwiftUI

@main
struct XpiryApp: App {
    @StateObject private var persistence = Persistence()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistence.container.viewContext)
        }
    }
}
