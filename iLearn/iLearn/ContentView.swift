//
//  ContentView.swift
//  iLearn
//
//  Created by Alex Balla on 30.09.2024.
//

import SwiftUI

struct Theme: Identifiable {
    let name: String
    let id = UUID()
}

struct ContentView: View {
    private var themes = [
        Theme(name: "Deutsch 1"),
        Theme(name: "GER Lesson 1 HW"),
        Theme(name: "English advanced C1")
    ]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(themes) { theme in
                    NavigationLink {
                        PlayModeView(selectedTheme: theme.name)
                    } label: {
                        Text(theme.name)
                    }
                }
            }
            .navigationTitle("All Themes")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                Button(action: {
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
