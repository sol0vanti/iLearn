//
//  ContentView.swift
//  iLearn
//
//  Created by Alex Balla on 30.09.2024.
//

import SwiftUI

struct Theme: Identifiable {  // Create a "Theme" structure as an element list
    let name: String
    let id = UUID()
}

struct ContentView: View {
    private var themes = [  // Set values for elements using "Theme" structure
        Theme(name: "Deutsch 1"),
        Theme(name: "GER Lesson 1 HW"),
        Theme(name: "English advanced C1")
    ]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(themes) { theme in // Loop all theme in themes list
                    NavigationLink { // Go to the "PlayModeView" on element click
                        PlayModeView(selectedTheme: theme.name)
                    } label: {
                        Text(theme.name) // Create a title for List element
                    }
                }
            }
            .navigationTitle("All Themes")
            .navigationBarTitleDisplayMode(.large)
            .toolbar { // Interact with toolbar
                Button(action: { // Add right toolbar plus button
                    print("add tapped")
                }) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct PlayModeView: View {
    var selectedTheme: String
    var body: some View {
        NavigationStack {
            Text("no code")
        }
        .navigationTitle(selectedTheme)
    }
}

#Preview {
    ContentView()
}
