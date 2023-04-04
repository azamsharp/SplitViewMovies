//
//  LearnApp.swift
//  Learn
//
//  Created by Mohammad Azam on 4/4/23.
//

import SwiftUI

@main
struct LearnApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, CoreDataManager.shared.persistentContainer.viewContext)
        }
    }
}
