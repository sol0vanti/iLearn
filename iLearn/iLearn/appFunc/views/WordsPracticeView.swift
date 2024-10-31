//
//  WordsPractiseView.swift
//  iLearn
//
//  Created by Alex Balla on 29.10.2024.
//

import SwiftUI

enum PracticeStage {
    case check, next
    
    func changeButtonText(textToCheck: String, textToVerifyFrom: String) -> String {
        switch self {
        case .check:
            if textToCheck == textToVerifyFrom {
                return "Next"
            } else {
                return "Check"
            }
        case .next:
            return "Check"
        }
    }
    
    func changeCheckText(textToCheck: String, textToVerifyFrom: String) -> String {
        switch self {
        case .check:
            if textToCheck == textToVerifyFrom {
                return "Correct"
            } else {
                return "Incorrect"
            }
        case .next:
            return ""
        }
    }
    
    func changeCheckTextColor(textToCheck: String, textToVerifyFrom: String) -> Color {
        switch self {
        case .check:
            if textToCheck == textToVerifyFrom {
                return .green
            } else {
                return .red
            }
        case .next:
            return .clear
        }
    }
}

struct WordsPracticeView: View {
    @StateObject var vm = CoreDataRelationshipViewModel()
    @State var textFieldText: String = ""
    @State var wordCount: Int = 0
    @State var mainWord = ""
    @State var targetWord = ""
    @State var checkText: String = ""
    @State var checkTextColor: Color = .white
    @State var showExitAlert: Bool = false
    @Environment(\.dismiss) var dismiss
    let entity: ThemeEntity
    let practiceMode: String
    @State var buttonText: String = "Check"
    @State var isCheckTextHidden: Bool = true
    @State var buttonPattern = PracticeStage.check
    
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
        switch buttonPattern {
        case .check:
            buttonText = buttonPattern.changeButtonText(textToCheck: textFieldText, textToVerifyFrom: targetWord)
            checkText = buttonPattern.changeCheckText(textToCheck: textFieldText, textToVerifyFrom: targetWord)
            checkTextColor = buttonPattern.changeCheckTextColor(textToCheck: textFieldText, textToVerifyFrom: targetWord)
            print(checkTextColor)
            if textFieldText == targetWord {
                buttonPattern = PracticeStage.next
                print(buttonPattern)
                wordCount += 1
            }
        case .next:
            buttonText = buttonPattern.changeButtonText(textToCheck: textFieldText, textToVerifyFrom: targetWord)
            checkText = buttonPattern.changeCheckText(textToCheck: textFieldText, textToVerifyFrom: targetWord)
            checkTextColor = buttonPattern.changeCheckTextColor(textToCheck: textFieldText, textToVerifyFrom: targetWord)
            buttonPattern = PracticeStage.check
            getRandomizedWord()
        }
    }
}
