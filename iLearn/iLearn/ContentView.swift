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
    @State private var showCreateAlert: Bool = false
    @State private var titleThemeTextFieldText: String = ""
    @State private var themes = [  // Set values for elements using "Theme" structure
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
                    showCreateAlert = true // Show the alert ob button tap
                }) {
                    Image(systemName: "plus")
                }.alert(
                    Text("Add new theme"), // Title for the alert
                    isPresented: $showCreateAlert // Switch on a variable
                ) {
                    Button("Cancel", role: .cancel) {} // Cancel button
                    Button("Create") {
                        if !titleThemeTextFieldText.isEmpty { // If the title is not equal nil ('!' at the begining) do the function
                            themes.append(Theme(name: titleThemeTextFieldText))
                            showCreateAlert = false // Hide the alert
                        }
                    }
                    
                    TextField("Title", text: $titleThemeTextFieldText) // Create a textField
                } message: {
                    Text("Create your new learning journey") // Alert message
                }
            }
        }
    }
}

struct PlayModeView: View {
    var selectedTheme: String
    var body: some View {
        NavigationStack {
            Button {
                    
            } label: {
                Text("Add")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .padding(.horizontal, 25)
            Spacer()
        }
        .navigationTitle(selectedTheme)
    }
}

#Preview {
    ContentView()
}
