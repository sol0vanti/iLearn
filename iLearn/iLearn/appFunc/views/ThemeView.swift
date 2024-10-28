//
//  ContentView.swift
//  iLearn
//
//  Created by Alex Balla on 30.09.2024.
//

import SwiftUI
import CoreData

struct Theme: Identifiable {  // Create a "Theme" structure as an element list
    var id: String?
    let name: String
}

struct ThemeView: View {
    @StateObject var vm = CoreDataRelationshipViewModel()
    @State private var showCreateAlert: Bool = false
    @State private var titleThemeTextFieldText: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.themes) { theme in // Loop all theme in saved themes entities
                    NavigationLink { // Go to the "PlayModeView" on element click
                        ThemeWordsView(entity: theme)
                    } label: {
                        Text(theme.name!) // Create a title for List element
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
                            vm.addTheme(name: titleThemeTextFieldText)
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

#Preview {
    ThemeView()
}
