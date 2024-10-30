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
    @State var targetWord = ""
    @State var checkText: String = ""
    @State var checkTextColor: Color = .white
    @State var buttonText: String = "Check"
    @State var showExitAlert: Bool = false
    @Environment(\.dismiss) var dismiss
    let entity: ThemeEntity
    let practiceMode: String
    @State var practiceStage: String = "Check"
    @State var isCheckTextHidden: Bool = true
    
    var body: some View {
        Spacer()
        Text(mainWord)
            .font(.title)
        TextField("Translated word", text: $textFieldText)
            .padding(.horizontal, 25)
            .textFieldStyle(.roundedBorder)
        Spacer()
        if isCheckTextHidden == false {
            Text(checkText)
                .font(.system(size: 14))
                .foregroundStyle(checkTextColor)
                .bold()
        }
        Button {
            checkWords()
        } label: {
            Text(practiceStage)
                .frame(maxWidth: .infinity)
                .padding(2)
                .bold()
        }
            .buttonStyle(.borderedProminent)
            .padding([.bottom, .trailing, .leading], 25)
            .onAppear {
                getRandomizedWord()
            }
            .alert(
                Text("You have finished the practice"),
                isPresented: $showExitAlert
            ) {
                Button("exit", role: .cancel) {
                    dismiss()
                }
            }
    }
    
    func getRandomizedWord() {
        guard let words = entity.words?.allObjects as? [WordEntity], wordCount < words.count else  {
            showExitAlert = true
            return
        }
        
        let currentWordsSet = words[wordCount]
    
        switch practiceMode {
            case "mainToTranslated":
                mainWord = currentWordsSet.mainWord ?? "error getting data"
                targetWord = currentWordsSet.translatedWord ?? "error getting data"
            case "translatedToMain":
                mainWord = currentWordsSet.translatedWord ?? "error getting data"
                targetWord = currentWordsSet.mainWord ?? "error getting data"
            default:
                showExitAlert = true
        }
    }
    
    func checkWords() {
        switch practiceStage {
            case "Check" :
                isCheckTextHidden = false
                guard textFieldText == targetWord else {
                    checkText = "Incorrect"
                    checkTextColor = .red
                    return
                }
                checkText = "Correct"
                checkTextColor = .green
                wordCount += 1
                practiceStage = "Next"
            case "Next":
                isCheckTextHidden = true
                textFieldText = ""
                practiceStage = "Check"
                getRandomizedWord()
            default:
                return
        }
    }
}
