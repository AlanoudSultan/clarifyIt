//
//  AddWors.swift
//  clarifyIt
//
//  Created by Maha Alsayed on 19/06/1446 AH.
//


import SwiftUI
import AVFoundation



struct AddWordView: View {
    @Environment(\.presentationMode) var presentationMode // To dismiss the current view
    @State private var word: String = "" // Stores the input word
    @State private var showAlert: Bool = false // Tracks whether to show an alert
    @State private var apiResult: [String: String] = [:] // Stores the API response
    @State private var showResultPage = false // Tracks whether to show the results page
    @State private var isSpeakerFull = false // Tracks the state of the speaker
    @State private var displayMode = 0 // Used to switch between meaning, synonyms, and example

    private let synthesizer = AVSpeechSynthesizer() // AVSpeechSynthesizer for text-to-speech
    @State private var speechManager: SpeechManager?

    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                HStack {
                    // Back Button or Close Button based on the view state
                    if showResultPage {
                        Button(action: {
                            showResultPage = false // Go back to input view
                        }) {
                            Image(systemName: "xmark")
                                .font(.title)
                                .foregroundColor(.gray)
                        }
                    } else {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss() // Dismiss the view
                        }) {
                            
                        }
                    }
                    Spacer()

                    // Speaker Button to play the word
                    if showResultPage {
                        Button(action: {
                            if let wordToSpeak = apiResult["word"] {
                                speak(text: wordToSpeak)
                                isSpeakerFull.toggle()
                            }
                        }) {
                            Image(systemName: isSpeakerFull ? "speaker.wave.3.fill" : "speaker.wave.3")
                                .font(.title)
                                .foregroundColor(Color("PurpleMatch"))
                        }
                        .padding()
                    }
                }
                .padding(.leading, 20)
                .padding(.top, 20)

                // Show Results Page
                if showResultPage {
                    VStack(spacing: 15) {
                        Text("Word of the Day!")
                            .font(.custom("SF Pro Display", size: 40))
                            .fontWeight(.regular)
                            .lineSpacing(20)
                        
                        Text(headerText)
                            .font(.custom("SF Pro Display", size: 18))
                            .fontWeight(.regular)
                            .lineSpacing(5)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)

                    // Display meaning, synonyms, or example based on the current mode
                    VStack(spacing: 30) {
                        if !apiResult.isEmpty {
                            Text(apiResult["word"] ?? "") // Display the word
                                .font(.custom("SF Pro Display", size: 45))
                                .foregroundColor(Color("PurpleMatch"))

                            Text(getCurrentDisplayText() ?? "") // Display the current mode's content
                                .font(.custom("SF Pro Display", size: 28))
                                .multilineTextAlignment(.center)
                                .padding()
                                .gesture(
                                    DragGesture()
                                        .onEnded { value in
                                            // Swipe gesture to change the mode
                                            if value.translation.width < 0 && displayMode < 2 {
                                                displayMode += 1
                                            } else if value.translation.width > 0 && displayMode > 0 {
                                                displayMode -= 1
                                            }
                                        }
                                )
                        } else {
                            Text("No data available")
                                .font(.title)
                                .foregroundColor(.red)
                        }
                    }
                    .frame(width: 330, height: 378)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color("PurpleMatch"), lineWidth: 3)
                    )
                    .padding(.horizontal)

                    // Page indicators
                    HStack {
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .fill(index == displayMode ? Color("PurpleMatch") : Color.gray)
                                .frame(width: 10, height: 10)
                        }
                    }
                    .padding(.top, 10)

                    Spacer()

                    // Show buttons only at the last displayMode
                    if displayMode == 2 {
                        HStack(spacing: 20) {
                            NavigationLink(destination: MainView(selectedCategory: "")) {
                                Text("Done")
                                    .font(.custom("SF Pro Display", size: 27))
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 180, height: 70)
                                    .background(Color("PurpleMatch"))
                                    .cornerRadius(15)
                            }

                            NavigationLink(destination: WritingView(word: word)) {
                                Text("Quiz")
                                    .font(.custom("SF Pro Display", size: 27))
                                    .fontWeight(.medium)
                                    .foregroundColor(Color("PurpleMatch"))
                                    .padding()
                                    .frame(width: 180, height: 70)
                                    .background(.white)
                                    .cornerRadius(15)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color("PurpleMatch"), lineWidth: 2)
                                    )
                            }
                        }
                        .padding(.bottom)
                    }
                }
 else {
                    // Input View to add a word
                    VStack(spacing: 40) {
                        Text("Write the word to add in the box")
                            .multilineTextAlignment(.center)
                            .font(.custom("SF Pro Text", size: 25))
                            .font(.headline)
                            .padding(.top, 40)
                        
                        TextField("Write here...", text: $word, axis: .vertical)
                            .font(.custom("SF Pro Text", size: 16)).fontWeight(.medium)
                            .padding()
                            .frame(width: 350, height: 150, alignment: .top)
                            .background(Color.gray1.opacity(0.5))
                            .cornerRadius(12)
                            .overlay(content: { RoundedRectangle(cornerRadius: 12).stroke(Color.dotsCO, lineWidth: 0.5) })
                        
                        Button(action: {
                            if word.isEmpty {
                                showAlert = true
                            } else {
                                fetchWordDetails() // Call API to fetch word details
                            }
                        }) {
                            Text("Add")
                                .font(.custom("SF Pro Text", size: 25))
                                .foregroundColor(.white1)
                                .frame(width: 300, height: 40)
                                .padding()
                                .background(Color.accent)
                                .cornerRadius(12)
                        }
                    }
                    Spacer()
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("No Word Written"), message: Text("Please enter a word before pressing Add."), dismissButton: .default(Text("Ok")))
                    }
                }
            }
            .onAppear {
                speechManager = SpeechManager(isSpeakerFull: $isSpeakerFull)
                synthesizer.delegate = speechManager
            }
        }
    }

    // Fetch word details using the API
    private func fetchWordDetails() {
        let apiService = APIService()
        apiService.fetchWordDetails(word: word) { response in
            DispatchQueue.main.async {
                if let response = response, !response.isEmpty {
                    let components = response.split(separator: "\n").map { String($0) }
                    if components.count >= 3 {
                        self.apiResult = [
                            "word": self.word,
                            "meaning": cleanText(components[0]),
                            "synonyms": cleanText(components[1], isSynonyms: true),
                            "example": cleanText(components[2])
                        ]
                        self.showResultPage = true
                    } else {
                        self.apiResult = ["word": self.word, "meaning": "Invalid API response"]
                    }
                } else {
                    self.apiResult = ["word": self.word, "meaning": "No valid result received from the API."]
                }
            }
        }
    }

    // Header text based on the display mode
    private var headerText: String {
        switch displayMode {
        case 0:
            return "This explains the meaning of the word"
        case 1:
            return "These are words that mean the same"
        case 2:
            return "This is a sentence showing how to use the word"
        default:
            return ""
        }
    }
    
    // Get the current display text based on the mode
    private func getCurrentDisplayText() -> String? {
        switch displayMode {
        case 0: return apiResult["meaning"]
        case 1: return apiResult["synonyms"]
        case 2: return apiResult["example"]
        default: return nil
        }
    }

    // Clean the API response text
    private func cleanText(_ text: String, isSynonyms: Bool = false) -> String {
        let unwantedPatterns = ["Definition:", "Synonyms:", "Example Sentence:", "\\*{2,}"]
        var cleanedText = text

        for pattern in unwantedPatterns {
            if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
                cleanedText = regex.stringByReplacingMatches(
                    in: cleanedText,
                    options: [],
                    range: NSRange(location: 0, length: cleanedText.utf16.count),
                    withTemplate: ""
                )
            }
        }

        cleanedText = cleanedText.trimmingCharacters(in: .whitespacesAndNewlines)

        if isSynonyms {
            return cleanedText.replacingOccurrences(of: ", ", with: "\n")
        }

        return cleanedText
    }

    // Speak the text using AVSpeechSynthesizer
    private func speak(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        synthesizer.speak(utterance)
    }
}

#Preview {
    AddWordView()
}
