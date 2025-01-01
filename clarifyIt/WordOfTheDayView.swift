import SwiftUI
import AVFoundation

struct WordOfTheDayView: View {
    @Binding var progress: Double  // Accept progress as a Binding
    @ObservedObject var data = DataLoader() // Observing the data source
    @AppStorage("currentIndex") private var currentIndex = 0 // Stores the current word index
    @AppStorage("displayMode") private var displayMode = 0 // Stores the current display mode (meaning, synonyms, sentence)
    
    @State private var isLearningComplete = false // Tracks whether learning is complete
    @State private var isSpeakerFull = false // Tracks speaker state
    private let synthesizer = AVSpeechSynthesizer() // Text-to-speech synthesizer
    
    @State private var speechManager: SpeechManager? // Manager for speech synthesis
    
    var body: some View {
        VStack(spacing: 40) {
            // Top bar with close button and speaker button
            HStack {
                // Navigation to MainView
                NavigationLink(destination: MainView().navigationBarBackButtonHidden(true)) {
                    
                }
                .padding()
                
                Spacer()
                
                // Speaker button to read out the word
                Button(action: {
                    if !data.literature.isEmpty {
                        speak(text: data.literature[currentIndex].Word)
                        isSpeakerFull.toggle()
                    }
                }) {
                    Image(systemName: isSpeakerFull ? "speaker.wave.3.fill" : "speaker.wave.3")
                        .font(.title)
                        .foregroundColor(Color("PurpleMatch"))
                }
                .padding()
            }
            .padding(5)
            
            // Title and header text
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
            
            // Main content area
            VStack(spacing: 30) {
                if !data.literature.isEmpty {
                    // Ensure the currentIndex is within bounds
                    let safeIndex = min(currentIndex, data.literature.count - 1)
                    // Display the current word
                    Text(data.literature[safeIndex].Word)
                        .font(.custom("SF Pro Display", size: 45))
                        .fontWeight(.bold)
                        .lineSpacing(20)
                        .foregroundColor(Color("PurpleMatch"))
                    
                    // Display meaning, synonyms, or example sentence based on the mode
                    if displayMode == 0 {
                        Text(data.literature[safeIndex].Levels.Low.Meaning)
                            .font(.custom("SF Pro Display", size: 28))
                            .fontWeight(.regular)
                            .lineSpacing(5)
                            .multilineTextAlignment(.center)
                            .padding()
                    } else if displayMode == 1 {
                        Text(data.literature[safeIndex].Levels.Low.Synonyms.joined(separator: "\n"))
                            .font(.custom("SF Pro Display", size: 30))
                            .fontWeight(.regular)
                            .lineSpacing(10)
                            .multilineTextAlignment(.center)
                            .padding()
                    } else if displayMode == 2 {
                        Text(data.literature[safeIndex].Levels.Low.Sentence)
                            .font(.custom("SF Pro Display", size: 28))
                            .fontWeight(.regular)
                            .lineSpacing(5)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    
                } else {
                    Text("No words available")
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
            
            // Dots to indicate the current display mode
            HStack {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(index == (displayMode) ? Color("PurpleMatch") : Color.gray)
                        .frame(width: 10, height: 10)
                }
            }
            .padding(.top, 1)
            
            if displayMode == 2 {
                actionButtons
            }
            
            Spacer()
        }
        // Gesture to switch between display modes
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < 0 {
                        if displayMode < 2 {
                            displayMode += 1
                        }
                    } else if value.translation.width > 0 {
                        if displayMode > 0 {
                            displayMode -= 1
                        }
                    }
                }
        )
        // Initialize the SpeechManager on appear
        .onAppear {
            speechManager = SpeechManager(isSpeakerFull: $isSpeakerFull)
            synthesizer.delegate = speechManager
        }
        .navigationBarBackButtonHidden(false)
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
    
    // Action buttons for Continue and Quiz
    private var actionButtons: some View {
        HStack(spacing: 20) {
            // Continue to the next word
            Button(action: {
                // Ensure the currentIndex stays within bounds
                currentIndex = (currentIndex + 1) % data.literature.count
                displayMode = 0
                
                // Update progress when Continue button is tapped
                progress = min(progress + 0.1, 1.0)  // Ensure it doesn't exceed 100%
            }) {
                Text("Continue")
                    .font(.custom("SF Pro Display", size: 27))
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 180, height: 70)
                    .background(Color("PurpleMatch"))
                    .cornerRadius(15)
            }
            
            // Navigate to the Quiz view
            NavigationLink(destination: WritingView(word: data.literature[currentIndex].Word)) {
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
        .padding(.horizontal)
    }
    
    // Speak the given text
    func speak(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.45
        utterance.pitchMultiplier = 1.1
        synthesizer.speak(utterance)
    }
}
