import SwiftUI
import AVFoundation

class SpeechManager: NSObject, AVSpeechSynthesizerDelegate {
    @Binding var isSpeakerFull: Bool

    init(isSpeakerFull: Binding<Bool>) {
        _isSpeakerFull = isSpeakerFull
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeakerFull = false
    }
}

struct WordOfTheDayView: View {
    @ObservedObject var data = DataLoader()
    @AppStorage("currentIndex") private var currentIndex = 0
    @AppStorage("displayMode") private var displayMode = 0
    @State private var isLearningComplete = false
    @State private var isSpeakerFull = false
    private let synthesizer = AVSpeechSynthesizer()
    
    @State private var speechManager: SpeechManager?

    var body: some View {
        VStack(spacing: 40) {
            HStack {
                Button(action: {
                }) {
                    Image(systemName: "xmark")
                        .font(.title)
                        .foregroundColor(Color.gray)
                }
                .padding()
                
                Spacer()
                
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
            
            VStack(spacing: 30) {
                if !data.literature.isEmpty {
                    Text(data.literature[currentIndex].Word)
                        .font(.custom("SF Pro Display", size: 45))
                        .fontWeight(.bold)
                        .lineSpacing(20)
                        .foregroundColor(Color("PurpleMatch"))
                    
                    if displayMode == 0 {
                        Text(data.literature[currentIndex].Levels.Low.Meaning)
                            .font(.custom("SF Pro Display", size: 28))
                            .fontWeight(.regular)
                            .lineSpacing(5)
                            .multilineTextAlignment(.center)
                            .padding()
                    } else if displayMode == 1 {
                        Text(data.literature[currentIndex].Levels.Low.Synonyms.joined(separator: "\n"))
                            .font(.custom("SF Pro Display", size: 30))
                            .fontWeight(.regular)
                            .lineSpacing(10)
                            .multilineTextAlignment(.center)
                            .padding()
                    } else if displayMode == 2 {
                        Text(data.literature[currentIndex].Levels.Low.Sentence)
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
        .onAppear {
            speechManager = SpeechManager(isSpeakerFull: $isSpeakerFull)
            synthesizer.delegate = speechManager
        }
    }
    
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
    
    private var actionButtons: some View {
        HStack(spacing: 20) {
            Button(action: {
                currentIndex = (currentIndex + 1) % data.literature.count
                displayMode = 0
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
            
            Button(action: {
            }) {
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
    
    func speak(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.45
        utterance.pitchMultiplier = 1.1
        synthesizer.speak(utterance)
    }
}

struct WordOfTheDayView_Previews: PreviewProvider {
    static var previews: some View {
        WordOfTheDayView()
    }
}
