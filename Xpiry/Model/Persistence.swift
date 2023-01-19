//
//  Persistence.swift
//  Xpiry
//
//  Created by Jason Kenneth on 29/11/22.
//

import CoreData

class Persistence: ObservableObject {
    let container = NSPersistentContainer(name: "Xpiry")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
