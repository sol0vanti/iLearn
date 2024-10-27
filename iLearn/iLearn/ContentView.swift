//
//  ContentView.swift
//  iLearn
//
//  Created by Alex Balla on 30.09.2024.
//

import SwiftUI
import CoreData

class CoreDataViewModel: ObservableObject {
    let container: NSPersistentContainer
    @Published var savedEntities: [ThemeEntity] = []
    
    init() {
        container = NSPersistentContainer(name: "ThemesContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        fetchThemes()
    }
    
    func fetchThemes() {
        let request = NSFetchRequest<ThemeEntity>(entityName: "ThemeEntity")
        
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print(error)
        }
    }
    
    func addTheme(name: String) {
        let newTheme = ThemeEntity(context: container.viewContext)
        newTheme.name = name
        saveData()
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
            fetchThemes()
        } catch let error {
            print(error)
        }
    }
}

struct Theme: Identifiable {  // Create a "Theme" structure as an element list
    var id: String?
    let name: String
}

struct ContentView: View {
    @StateObject var vm = CoreDataViewModel()
    @State private var showCreateAlert: Bool = false
    @State private var titleThemeTextFieldText: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.savedEntities) { theme in // Loop all theme in saved themes entities
                    NavigationLink { // Go to the "PlayModeView" on element click
                        PlayModeView(selectedTheme: theme.name!)
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

struct PlayModeView: View {
    var selectedTheme: String
    var body: some View {
        NavigationStack {
            Button {
                    
            } label: {
                Text("Add word")
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
