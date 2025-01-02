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
    @State private var navigateToQuiz: Bool = false // To trigger navigation
    @ObservedObject var dataLoader = DataLoader() // Load data for random word selection

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Back Button
                // Back Button
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // Dismiss to the previous view
                    }) {
                    }

                    Spacer() // Push the button to the left side
                }
                .padding(.horizontal, 1)


                // Title Text
                Text("Which type of a test do you want?")
                    .font(.system(size: 24, weight: .medium))
                    .multilineTextAlignment(.center)
                    .padding(.top, 40)
                    .padding(.bottom, 15)

                // Matching Button
                Button(action: {
                    selectedQuiz = "Matching"  // Select Matching
                }) {
                    ZStack { // Add spacing between icon and text
                        
                        Text("Matching")
                            .font(.custom("SF Pro", size: 24))
                            .fontWeight(.medium)
                            .foregroundColor(.accentColor)
                        
                        HStack{
                            Image(systemName: "checkmark.rectangle.stack")
                                .font(.system(size: 23, weight: .medium))
                                .foregroundColor(.accentColor)
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    .frame(width: 327, height: 75)
                    .background(Color.purple3.opacity(0.2)) // Background color
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(selectedQuiz == "Matching" ? Color.accentColor : Color("dotsCO"), lineWidth: 2) // Highlight the selected button
                    )
                }
                .padding(.horizontal, 20)

                // Writing Button
                Button(action: {
                    selectedQuiz = "Writing"  // Select Writing
                }) {
                    ZStack { // Add spacing between icon and text
                        Text("Writing")
                            .font(.custom("SF Pro", size: 24))
                            .fontWeight(.medium)
                            .foregroundColor(.accentColor)
                            .frame(width: 110, height: 75)
                        
                        HStack(spacing: 10) { // Add spacing between icon and text
                            Image(systemName: "pencil.line")
                                .font(.system(size: 23, weight: .medium))
                                .foregroundColor(.accentColor)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    .frame(width: 327, height: 75)
                    .background(Color.purple3.opacity(0.2)) // Background color
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(selectedQuiz == "Writing" ? Color.accentColor : Color("dotsCO"), lineWidth: 2) // Highlight the selected button
                    )
                }
                .padding(.horizontal, 20)

                // Start Button
                NavigationLink(
                    destination: getDestinationView(),
                    isActive: $navigateToQuiz
                ) {
                    Button(action: {
                        if selectedQuiz != nil {
                            navigateToQuiz = true // Trigger navigation only when Start is pressed
                        }
                    }) {
                        Text("Start")
                            .font(.custom("SF Pro", size: 24))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 327, height: 75)
                            .background(Color.accentColor) // Always active
                            .cornerRadius(12)
                    }
                }
                .padding(.top, 20) // Add top padding to separate from quiz type buttons

                Spacer() // To push content up
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
        }
    }

    @ViewBuilder
    private func getDestinationView() -> some View {
        if selectedQuiz == "Matching" {
            MatchingView()
        } else if selectedQuiz == "Writing" {
            let randomWord = randomWord()
            WritingView(word: randomWord)
        } else {
            EmptyView()
        }
    }

    // Fetch a random word from all available categories
    private func randomWord() -> String {
        let allWords = dataLoader.literature + dataLoader.academic + dataLoader.general
        return allWords.randomElement()?.Word ?? "Placeholder"
    }
}


#Preview {
    DailyQuizView()
}
