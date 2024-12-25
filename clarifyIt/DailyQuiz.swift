//
//  DailyQuiz.swift
//  clarifyIt
//
//  Created by Maha Alsayed on 19/06/1446 AH.
//

import SwiftUI

struct DailyQuizView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedQuiz: String?

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

            // Title Text
            Text("Which type of a test do you want?")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.top, 40)

            // Matching Button
            Button(action: {
                selectedQuiz = "Matching"  // Select Matching
            }) {
                Text("Matching")
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple.opacity(0.2)) // Background color change
                    .cornerRadius(30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(selectedQuiz == "Matching" ? Color.accent : Color.dotsCO, lineWidth: 2)  // Border color change
                    )
                    .padding(.horizontal, 20)
            }

            // Writing Button
            Button(action: {
                selectedQuiz = "Writing"  // Select Writing
            }) {
                Text("Writing")
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple.opacity(0.2))// Background color change
                    .cornerRadius(30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(selectedQuiz == "Writing" ? Color.accent : Color.dotsCO, lineWidth: 2)  // Border color change
                    )
                    .padding(.horizontal, 20)
            }

            // Start Button
            Button(action: {
                // Handle start quiz functionality here
            }) {
                Text("Start")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
                    .padding(.top, 20) // Add top padding to separate from quiz type buttons
            }

            Spacer() // To push content up
        }
        .padding(.top, 20)
        .padding(.horizontal, 20)
    }
}

struct DailyQuizView_Previews: PreviewProvider {
    static var previews: some View {
        DailyQuizView()
    }
}

