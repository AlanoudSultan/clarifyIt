//
//  AddWors.swift
//  clarifyIt
//
//  Created by Maha Alsayed on 19/06/1446 AH.
//

import SwiftUI

struct AddWordView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var word: String = ""
    @State private var showAlert: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            // Back Button
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()  // Dismiss the view
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.accentColor)
                            .imageScale(.large)
                        Text("Back")
                            .foregroundColor(.accentColor)
                    }
                }
                Spacer() // Push the button to the left side
            }
            .padding(.leading, 20)
            .padding(.top, 20)
                
            Text("Write the word to add in the box")
                .multilineTextAlignment(.center)
                .font(.custom("SF Pro Text", size: 20))
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.top, 40)

            
            TextField("Write here...", text: $word)
                .padding()
                .frame(width: 350, height: 150)
                .background(Color.gray1.opacity(0.5))
                .cornerRadius(30)
                .overlay(content: { RoundedRectangle(cornerRadius: 30).stroke(Color.dotsCO, lineWidth: 2) })
            
                .padding()

            Button(action: {
                if word.isEmpty {
                    showAlert = true
                } else {
                    // Handle the add word functionality
                }
            }) {
                Text("Add")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accent)
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
            }

        }
        Spacer()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("No Word Written"), message: Text("Write a word in the box before pressing the button"), dismissButton: .default(Text("Ok")))
        }
    }
}


#Preview {
    AddWordView()
}
