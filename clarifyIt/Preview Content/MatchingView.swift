//////
//////  MatchingView.swift
//////  clarifyIt
//////
//////  Created by Alanoud Abaalkhail on 16/06/1446 AH.
//////
//
//import SwiftUI
//
//struct MatchingView: View {
//    @State private var wordSentencePairs: [(word: String, sentence: String)] = [
//        ("Embrace", "The sun offers a warm embrace"),
//        ("Descent", "An apple lands in its descent"),
//        ("Sanctuary", "The forest is nature’s sanctuary")
//    ]
//    @State private var selectedWord: String? = nil
//    @State private var selectedSentence: String? = nil
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                
//                // Navigation Button and Progress Bar in Same Line
//                HStack {
//                    Button(action: {
//                        // Handle the back action
//                        print("Back button tapped")
//                    }) {
//                        Image(systemName: "chevron.left")
//                            .font(.system(size: 24, weight: .heavy))
//                            .foregroundColor(Color("PurpleMatch"))
//                    }
//            
//                    //Progress Bar
//                    ZStack(alignment: .leading) {
//                        // Background Track
//                        Capsule()
//                            .fill(Color.green2.opacity(0.2)) // Light green for background
//                            .frame(width: UIScreen.main.bounds.width - 90, height: 10)  // Customize width and height here
//                        
//                        Capsule()
//                            .fill(Color.green2) // Solid green for progress
//                            .frame(width: 300 * 0.1, height: 10) // Adjust width based on progress value
//                    }
//                    .frame(maxWidth: .infinity) // Allow progress bar to adjust its size
//                }
//                .padding()
//                .padding(.top, 20)
//
//                // Title Text
//                Text("Match the word with the right sentence")
//                    .font(.system(size: 24, weight: .medium))
//                    .multilineTextAlignment(.center)
//                    .frame(width: 260, height: 60)
//                    .padding()
//                
//                // Matching Pairs UI
//                VStack(spacing: 20) {
//                    ForEach(wordSentencePairs, id: \.word) { pair in
//                        HStack(spacing: 20) {
//                            // Word Box
//                            Text(pair.word)
//                                .font(.system(size: 24, weight: .medium))
//                                .multilineTextAlignment(.center)
//                                .frame(width: UIScreen.main.bounds.width - 250, height: 150)
//                                .background(Color.white)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 12)
//                                        .stroke(
//                                            selectedWord == pair.word ? Color("PurpleMatch") : Color("purple 3"),
//                                            lineWidth: selectedWord == pair.word ? 7 : 1
//                                        )
//                                )
//                                .onTapGesture {
//                                    selectedWord = (selectedWord == pair.word) ? nil : pair.word
//                                }
//                            
//                            // Sentence Box
//                            Text(pair.sentence)
//                                .font(.system(size: 24, weight: .medium))
//                                .multilineTextAlignment(.leading)
//                                .padding(.leading, 10.0)
//                                .lineSpacing(3)
//                                .frame(width: UIScreen.main.bounds.width - 250, height: 150)
//                                .background(Color.white)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 12)
//                                        .stroke(
//                                            selectedSentence == pair.sentence ? Color("PurpleMatch") : Color("purple 3"),
//                                            lineWidth: selectedSentence == pair.sentence ? 7 : 1
//                                        )
//                                )
//                                .onTapGesture {
//                                    selectedSentence = (selectedSentence == pair.sentence) ? nil : pair.sentence
//                                }
//                        }
//                    }
//                }
//                .padding()
//                
//                
//                // Check Button
//                Button(action: {
//                    // Action when "Check" is pressed
//                    print("Check button tapped")
//                }) {
//                    Text("Check")
//                        .font(.system(size: 24, weight: .medium))
//                        .foregroundColor((selectedWord != nil || selectedSentence != nil) ?  Color.white : Color.gray)
//                        .frame(maxWidth: UIScreen.main.bounds.width - 70 , minHeight: 66)
//                        .background((selectedWord != nil || selectedSentence != nil) ?  Color("PurpleMatch") : Color("Gray 2"))
//                        .cornerRadius(12)
//                }
//                .padding()
//
//            }
//            .background(Color.white)
//            .navigationBarTitleDisplayMode(.inline)
//            .navigationBarBackButtonHidden(true) // Hide default back button to use custom button
//        }
//    }
//}
//
//#Preview {
//    MatchingView()
//}




import SwiftUI

struct MatchingView: View {
    @ObservedObject var modelView = ModelView() // Observing the ModelView

    @State private var selectedCard: Card? = nil
    @State private var isMatchChecked = false // To track if a match has been checked
    @State private var matchResult: Bool? = nil // To track the match result (true = correct, false = wrong)

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

                    // Progress Bar
                    ZStack(alignment: .leading) {
                        // Background Track
                        Capsule()
                            .fill(Color.green2.opacity(0.2)) // Light green for background
                            .frame(width: UIScreen.main.bounds.width - 90, height: 10)
                        
                        Capsule()
                            .fill(Color.green2) // Solid green for progress
                            .frame(width: 300 * 0.1, height: 10) // Adjust width based on progress value
                    }
                    .frame(maxWidth: .infinity)
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
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 20) {
                    ForEach(modelView.cards) { card in
                        VStack {
                            // Word Box
                            Text(card.value)
                                .font(.system(size: 20, weight: .medium))
                                .multilineTextAlignment(.center)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            // Conditional stroke color based on match result or selection state
                                            selectedCard?.id == card.id ?
                                            (matchResult == true ? Color.green : (matchResult == false ? Color.red : Color("purple 3"))) :
                                            (matchResult == nil ? Color("purple 3") : Color.gray),
                                            lineWidth: 7
                                        )
                                )
                                .onTapGesture {
                                    // Use selectCard method from ModelView to handle card selection
                                    modelView.selectCard(card)
                                    selectedCard = card
                                    isMatchChecked = false // Reset check flag when selecting a new card
                                }

                            // Sentence Box (this can be updated to show real sentence if required)
                            Text(card.value) // You can replace this with sentence if needed
                                .font(.system(size: 18, weight: .medium))
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 10.0)
                                .lineSpacing(3)
                                .frame(maxWidth: .infinity, minHeight: 100)
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            // Conditional stroke color based on match result or selection state
                                            selectedCard?.id == card.id ?
                                            (matchResult == true ? Color.green : (matchResult == false ? Color.red : Color("purple 3"))) :
                                            (matchResult == nil ? Color("purple 3") : Color.gray),
                                            lineWidth: 7
                                        )
                                )
                                .onTapGesture {
                                    // Handle sentence tap (if applicable)
                                }
                        }
                    }
                }
                .padding()

                // Check Button
                Button(action: {
                    // Action when "Check" is pressed
                    modelView.matchingCards() // Call matchingCards to check if the match is correct
                    isMatchChecked = true // Set the match check flag to true
                    
                    // Check if the two selected cards match
                    if modelView.selectedCards.count == 2 {
                        let firstCard = modelView.selectedCards[0]
                        let secondCard = modelView.selectedCards[1]
                        
                        matchResult = (firstCard.value == secondCard.value) // Set match result
                    }
                    
                    // Disable the check button and change its color
                    selectedCard = nil // Optionally, reset selected card after checking
                }) {
                    Text("Check")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor((selectedCard != nil) ?  Color.white : Color.gray)
                        .frame(maxWidth: UIScreen.main.bounds.width - 70 , minHeight: 66)
                        .background((selectedCard != nil) ?  Color("PurpleMatch") : Color("Gray 2"))
                        .cornerRadius(12)
                        .disabled(selectedCard == nil || isMatchChecked) // Disable button after checking
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
