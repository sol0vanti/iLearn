//
//  PlayModeView.swift
//  iLearn
//
//  Created by Alex Balla on 28.10.2024.
//

import SwiftUI
import CoreData

struct ThemeWordsView: View {
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