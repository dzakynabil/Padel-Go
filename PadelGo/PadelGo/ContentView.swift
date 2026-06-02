//
//  ContentView.swift
//  PadelGo
//
//  Created by Macbook on 2/06/26.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar.fill")
                }
                .tag(0)
            
            ProgressTrackingView()
                .tabItem {
                    Label("Progress", systemImage: "slider.horizontal.3")
                }
                .tag(1)
            
            SmartScheduleView()
                .tabItem {
                    Label("Schedule", systemImage: "calendar")
                }
                .tag(2)
            
            ExerciseGuideView()
                .tabItem {
                    Label("Guide", systemImage: "book.fill")
                }
                .tag(3)
        }
    }
}

#Preview {
    ContentView()
}
