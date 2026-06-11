//
//  PadelGoApp.swift
//  PadelGo
//
//  Created by Macbook on 2/06/26.
//

import SwiftUI
import Firebase

@main
struct PadelGoApp: App {

    init() {
        FirebaseApp.configure()
    
    }

    var body: some Scene {
        WindowGroup {
            ContentView() 
        }
    }
}
