//
//  OndePareiApp.swift
//  OndeParei
//
//  Created by Felipe Diffonte Schmidt on 05/01/26.
//

import SwiftUI
import CoreData

@main
struct OndePareiApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
