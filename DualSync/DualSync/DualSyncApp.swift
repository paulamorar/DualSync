//
//  DualSyncApp.swift
//  DualSync
//
//  Created by Paula Mora Romero on 11/11/25.
//

import SwiftUI
import CoreData

@main
struct DualSyncApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            Screen1()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
