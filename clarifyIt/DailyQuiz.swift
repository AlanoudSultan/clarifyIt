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
                .font(.system(size: 24, weight: .medium))
                .multilineTextAlignment(.center)
                .padding(.top, 40)
                .padding(.bottom, 40)

            // Matching Button
                        Button(action: {
                            selectedQuiz = "Matching"  // Select Matching
                        }) {
                            HStack(spacing: 10) { // Add spacing between icon and text
                                Image(systemName: "checkmark.square")
                                    .font(.system(size: 23, weight: .medium))
                                    .foregroundColor(.accentColor)

                                Text("Matching")
                                    .font(.custom("SF Pro", size: 23))
                                    .fontWeight(.medium)
                                    .foregroundColor(.accentColor)
                            }
                            .frame(width: 327, height: 75)
                            .background(Color.purple.opacity(0.2)) // Background color
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(selectedQuiz == "Matching" ? Color.accentColor : Color("dotsCO"), lineWidth: 2) // Highlight the selected button
                            )
                        }
                        .padding(.horizontal, 20)

            // Writing Button
                       Button(action: {
                           selectedQuiz = "Writing"  // Select Writing
                       }) {
                           HStack(spacing: 10) { // Add spacing between icon and text
                               Image(systemName: "pencil")
                                   .font(.system(size: 23, weight: .medium))
                                   .foregroundColor(.accentColor)

                               Text("Writing")
                                   .font(.custom("SF Pro", size: 23))
                                   .fontWeight(.medium)
                                   .foregroundColor(.accentColor)
                           }
                           .frame(width: 327, height: 75)
                           .background(Color.purple.opacity(0.2)) // Background color
                           .cornerRadius(15)
                           .overlay(
                               RoundedRectangle(cornerRadius: 15)
                                   .stroke(selectedQuiz == "Writing" ? Color.accentColor : Color("dotsCO"), lineWidth: 2) // Highlight the selected button
                           )
                       }
                       .padding(.horizontal, 20)

            // Start Button
            Button(action: {
                // Handle start quiz functionality here
            }) {
                Text("Start")
                    .font(.custom("SF Pro", size: 23))
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 327, height: 75)
                    .background(Color.accentColor)
                    .cornerRadius(15)
            }
            .padding(.top, 20) // Add top padding to separate from quiz type buttons

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

