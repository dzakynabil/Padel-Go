//
//  Padel_GoApp.swift
//  Padel Go
//
//  Created by student on 29/05/26.
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

