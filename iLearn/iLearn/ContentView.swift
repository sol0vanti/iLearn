//
//  ContentView.swift
//  iLearn
//
//  Created by Alex Balla on 30.09.2024.
//

import SwiftUI
import CoreData

class CoreDataManager {
    static let instance = CoreDataManager()
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "ThemesContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        context = container.viewContext
    }
    
    func save() {
        do {
            try context.save()
        } catch let error {
            print(error)
        }
    }
}

class CoreDataRelationshipViewModel: ObservableObject {
    let manager = CoreDataManager.instance
    @Published var themes: [ThemeEntity] = []
    @Published var words: [WordEntity] = []
    
    init() {
        fetchThemes()
        fetchWords()
    }
    
    func fetchThemes() {
        let request = NSFetchRequest<ThemeEntity>(entityName: "ThemeEntity")
        
        do {
            themes = try manager.context.fetch(request)
        } catch let error {
            print(error)
        }
    }
    
    func fetchWords() {
        let request = NSFetchRequest<WordEntity>(entityName: "WordEntity")
        
        do {
            words = try manager.context.fetch(request)
        } catch let error {
            print(error)
        }
    }
    
    func addTheme(name: String) {
        let newTheme = ThemeEntity(context: manager.context)
        newTheme.name = name
        saveData()
    }
    
    func addWord(mainWord: String, translatedWord: String, theme: ThemeEntity) {
        let newWord = WordEntity(context: manager.context)
        newWord.mainWord = mainWord
        newWord.translatedWord = translatedWord
        newWord.theme = theme
        saveData()
    }
    
    func saveData() {
        manager.save()
        fetchThemes()
        fetchWords()
    }
}

struct Theme: Identifiable {  // Create a "Theme" structure as an element list
    var id: String?
    let name: String
}

struct ContentView: View {
    @StateObject var vm = CoreDataRelationshipViewModel()
    @State private var showCreateAlert: Bool = false
    @State private var titleThemeTextFieldText: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.themes) { theme in // Loop all theme in saved themes entities
                    NavigationLink { // Go to the "PlayModeView" on element click
                        PlayModeView(entity: theme)
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
    @StateObject var vm = CoreDataRelationshipViewModel()
    let entity: ThemeEntity
    @State var showAddWordAlert: Bool = false
    @State var alertMainWordTextFieldText: String = ""
    @State var alertTranslatedWordTextFieldText: String = ""
    
    var body: some View {
        NavigationStack {
            if let words = entity.words?.allObjects as? [WordEntity] {
                List {
                    if !words.isEmpty {
                        Section("Words:") {
                            ForEach(words) { word in
                                Text("\(word.mainWord ?? "error saving data") - \(word.translatedWord ?? "error saving data")")
                            }
                        }
                    } else {
                        Text("No words yet")
                            .multilineTextAlignment(.center)
                    }
                }
            }
            Button {
                showAddWordAlert = true
            } label: {
                Text("Add word")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .padding(.horizontal, 25)
            .alert(
                Text("Add new word"), // Title for the alert
                isPresented: $showAddWordAlert // Switch on a variable
            ) {
                Button("Cancel", role: .cancel) {} // Cancel button
                Button("Create") {
                    if !alertMainWordTextFieldText.isEmpty && !alertTranslatedWordTextFieldText.isEmpty {
                        vm.addWord(mainWord: alertMainWordTextFieldText, translatedWord: alertTranslatedWordTextFieldText, theme: self.entity)
                        showAddWordAlert = false // Hide the alert
                    }
                }
                
                TextField("Main word", text: $alertMainWordTextFieldText)
                TextField("Translated word", text: $alertTranslatedWordTextFieldText)
            }
        }
        .navigationTitle(entity.name ?? "error retrieving data")
    }
}

#Preview {
    ContentView()
}
