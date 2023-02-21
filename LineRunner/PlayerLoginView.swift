//
//  PlayerLoginView.swift
//  LineRunner
//
//  Created by Jonas Sjögren on 2023-02-20.
//
import SwiftUI
import Foundation
import FirebaseFirestoreSwift
import Firebase
import FirebaseAuth

 struct PlayerLoginView: View {
    
    @State var signedIn = false
    
    var body: some View {
        if !signedIn {
            SigningInView(signedIn: $signedIn)
        } else   {
            GameView()
        }
    }
}

struct SigningInView: View {
    @Binding var signedIn : Bool
    
    var body: some View {
        Text("Signing in...")
            .onAppear(){
                Auth.auth().signInAnonymously { authResult, error in
                    if let error = error {
                        print("error signing in \(error)")
                    } else {
                        print("Signed in \(Auth.auth().currentUser?.uid)")
                        signedIn = true
                    }
                }
            }
    }
}
