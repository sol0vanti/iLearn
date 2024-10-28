//
//  CoreDataRelationshipViewModel.swift
//  iLearn
//
//  Created by Alex Balla on 28.10.2024.
//

import SwiftUI
import CoreData

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
