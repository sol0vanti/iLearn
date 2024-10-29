//
//  WordsPractiseView.swift
//  iLearn
//
//  Created by Alex Balla on 29.10.2024.
//

import SwiftUI

struct WordsPracticeView: View {
    @StateObject var vm = CoreDataRelationshipViewModel()
    @State var textFieldText: String = ""
    @State var wordCount: Int = 0
    @State var mainWord = ""
    @State var translatedWord = ""
    @State var checkText: String = ""
    @State var checkTextColor: Color = .white
    @State var buttonText: String = "Check"
    let entity: ThemeEntity
    
    var body: some View {
        Spacer()
        Text(mainWord)
            .font(.title)
        TextField("Translated word", text: $textFieldText)
            .padding(.horizontal, 25)
            .textFieldStyle(.roundedBorder)
        Spacer()
        Text(checkText)
            .font(.system(size: 14))
            .foregroundStyle(checkTextColor)
            .bold()
        Button {
            checkWords()
        } label: {
            Text(buttonText)
                .frame(maxWidth: .infinity)
                .padding(2)
                .bold()
        }
            .buttonStyle(.borderedProminent)
            .padding([.bottom, .trailing, .leading], 25)
            .onAppear {
                getRandomizedWord()
            }
    }
    
    func getRandomizedWord() {
        if let words = entity.words?.allObjects as? [WordEntity] {
            if !words.isEmpty {
                let currentWordsSet = words[wordCount]
                mainWord = currentWordsSet.mainWord ?? "error getting data"
                translatedWord = currentWordsSet.translatedWord ?? "error getting data"
            }
        }
    }
    
    func checkWords() {
        if buttonText == "Check" {
            if textFieldText == translatedWord {
                checkText = "Correct"
                checkTextColor = .green
                wordCount += 1
                buttonText = "Next"
            } else {
                checkText = "Incorrect"
                checkTextColor = .red
            }
        } else if buttonText == "Next" {
            checkTextColor = .white
            getRandomizedWord()
            buttonText = "Check"
        }
    }
}
