////
////  MatchingView.swift
////  clarifyIt
////
////  Created by Alanoud Abaalkhail on 16/06/1446 AH.
////

import SwiftUI

struct MatchingView: View {
    @State private var wordSentencePairs: [(word: String, sentence: String)] = [
        ("Embrace", "The sun offers a warm embrace"),
        ("Descent", "An apple lands in its descent"),
        ("Sanctuary", "The forest is nature’s sanctuary")
    ]
    @State private var selectedWord: String? = nil
    @State private var selectedSentence: String? = nil

    var body: some View {
        NavigationView {
            VStack {
                
                // Navigation Button and Progress Bar in Same Line
                HStack {
                    Button(action: {
                        // Handle the back action
                        print("Back button tapped")
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24, weight: .heavy))
                            .foregroundColor(Color("PurpleMatch"))
                    }
            
                    //Progress Bar
                    ZStack(alignment: .leading) {
                        // Background Track
                        Capsule()
                            .fill(Color.green2.opacity(0.2)) // Light green for background
                            .frame(width: UIScreen.main.bounds.width - 90, height: 10)  // Customize width and height here
                        
                        Capsule()
                            .fill(Color.green2) // Solid green for progress
                            .frame(width: 300 * 0.1, height: 10) // Adjust width based on progress value
                    }
                    .frame(maxWidth: .infinity) // Allow progress bar to adjust its size
                }
                .padding()
                .padding(.top, 20)

                // Title Text
                Text("Match the word with the right sentence")
                    .font(.system(size: 24, weight: .medium))
                    .multilineTextAlignment(.center)
                    .frame(width: 260, height: 60)
                    .padding()
                
                // Matching Pairs UI
                VStack(spacing: 20) {
                    ForEach(wordSentencePairs, id: \.word) { pair in
                        HStack(spacing: 20) {
                            // Word Box
                            Text(pair.word)
                                .font(.system(size: 24, weight: .medium))
                                .multilineTextAlignment(.center)
                                .frame(width: UIScreen.main.bounds.width - 250, height: 150)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            selectedWord == pair.word ? Color("PurpleMatch") : Color("purple 3"),
                                            lineWidth: selectedWord == pair.word ? 7 : 1
                                        )
                                )
                                .onTapGesture {
                                    selectedWord = (selectedWord == pair.word) ? nil : pair.word
                                }
                            
                            // Sentence Box
                            Text(pair.sentence)
                                .font(.system(size: 24, weight: .medium))
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 10.0)
                                .lineSpacing(3)
                                .frame(width: UIScreen.main.bounds.width - 250, height: 150)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            selectedSentence == pair.sentence ? Color("PurpleMatch") : Color("purple 3"),
                                            lineWidth: selectedSentence == pair.sentence ? 7 : 1
                                        )
                                )
                                .onTapGesture {
                                    selectedSentence = (selectedSentence == pair.sentence) ? nil : pair.sentence
                                }
                        }
                    }
                }
                .padding()
                
                
                // Check Button
                Button(action: {
                    // Action when "Check" is pressed
                    print("Check button tapped")
                }) {
                    Text("Check")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor((selectedWord != nil || selectedSentence != nil) ?  Color.white : Color.gray)
                        .frame(maxWidth: UIScreen.main.bounds.width - 70 , minHeight: 66)
                        .background((selectedWord != nil || selectedSentence != nil) ?  Color("PurpleMatch") : Color("Gray 2"))
                        .cornerRadius(12)
                }
                .padding()

            }
            .background(Color.white)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true) // Hide default back button to use custom button
        }
    }
}

#Preview {
    MatchingView()
}
