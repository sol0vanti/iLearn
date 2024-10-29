//
//  WordsPractiseView.swift
//  iLearn
//
//  Created by Alex Balla on 29.10.2024.
//

import SwiftUI

struct WordsPracticeView: View {
    @State var textFieldText: String = ""
    
    var body: some View {
        Spacer()
        Text("Main word")
            .font(.title)
        TextField("Translated word", text: $textFieldText)
            .padding(.horizontal, 25)
            .textFieldStyle(.roundedBorder)
        Spacer()
        Text("Correct/Incorrect")
            .font(.system(size: 14))
            .foregroundStyle(.green)
            .bold()
        Button {
            
        } label: {
            Text("Check")
                .frame(maxWidth: .infinity)
                .padding(2)
                .bold()
        }
        .buttonStyle(.borderedProminent)
        .padding([.bottom, .trailing, .leading], 25)
    }
}
