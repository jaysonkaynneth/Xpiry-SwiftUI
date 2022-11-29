//
//  XpiryApp.swift
//  Xpiry
//
//  Created by Jason Kenneth on 29/11/22.
//

import SwiftUI

@main
struct XpiryApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
