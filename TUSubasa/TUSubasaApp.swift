//
//  TUSubasaApp.swift
//  TUSubasa
//
//  Created by Alperen Kaya on 22.11.2025.
//

import SwiftUI
import CoreData

@main
struct TUSubasaApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
