//
//  LineRunnerApp.swift
//  LineRunner
//
//  Created by Jonas Sjögren on 2023-02-14.
//

import SwiftUI
import Firebase

@main
struct LineRunnerApp: App {

    init() {
   FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
              //  .environmentObject(coordinates)
        }
    }
}
