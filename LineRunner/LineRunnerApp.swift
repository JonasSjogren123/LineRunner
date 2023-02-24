//
//  LineRunnerApp.swift
//  LineRunner
//
//  Created by Jonas Sjögren on 2023-02-14.
// Branch CoordinatesToFirestore
// Branch tmp2

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct LineRunnerApp: App {

    init() {
   FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            //ContentView()
            PlayerLoginView()
        }
    }
}
