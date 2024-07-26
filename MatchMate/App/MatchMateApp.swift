//
//  MatchMateApp.swift
//  MatchMate
//
//  Created by AMRUT WAGHMARE on 24/07/24.
//

import SwiftUI

@main
struct MatchMateApp: App {
    // MARK: Core data
    @StateObject private var manager: CoreDataManager = CoreDataManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            // MARK: Core data
                .environmentObject(manager)
                .environment(\.managedObjectContext, manager.container.viewContext)
        }
    }
}
