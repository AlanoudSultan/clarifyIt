//
//  WordOfTheDayView.swift
//  clarifyIt
//
//  Created by Nahed Almutairi on 23/12/2024.
//

import SwiftUI
import AVFoundation

struct WordOfTheDayView: View {
    @ObservedObject var data = DataLoader()
    @State private var currentIndex = 0
    @State private var displayMode = 0
    
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
                    }
                }) {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.title)
                        .foregroundColor(Color("PurpleMatch"))
                }
                .padding()
            }
            .padding(5)
            
     
            VStack(spacing: 25) {
                Text("Word of the Day!")
                    .font(.custom("SF Pro Display", size: 40))
                    .fontWeight(.regular)
                    .lineSpacing(20)
                
                Text("This explains the meaning of the word")
                    .font(.custom("SF Pro Display", size: 22))
                    .fontWeight(.regular)
                    .lineSpacing(20)
                    .foregroundColor(.black)
            }
            
      
            VStack(spacing: 30) {
                if !data.literature.isEmpty {
                    Text(data.literature[currentIndex].Word)
                        .font(.custom("SF Pro Display", size: 45))
                        .fontWeight(.semibold)
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
                        Text(data.literature[currentIndex].Levels.Low.Synonyms.joined(separator: ", "))
                            .font(.custom("SF Pro Display", size: 28))
                            .fontWeight(.regular)
                            .lineSpacing(5)
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
                        .fill(index == (currentIndex % 3) ? Color("PurpleMatch") : Color.gray)
                        .frame(width: 10, height: 10)
                }
            }
            .padding(.top, 1) // نقل المؤشرات تحت المربع مباشرة
            
            Spacer()
        }
        
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < 0 {
                        if displayMode < 2 {
                            displayMode += 1
                        } else {
                            displayMode = 0
                            currentIndex = (currentIndex + 1) % data.literature.count
                        }
                    } else if value.translation.width > 0 {
                        if displayMode > 0 {
                            displayMode -= 1
                        } else {
                            currentIndex = (currentIndex - 1 + data.literature.count) % data.literature.count
                            displayMode = 2
                        }
                    }
                }
        )
    }
    
  
    func speak(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
}

struct WordOfTheDayView_Previews: PreviewProvider {
    static var previews: some View {
        WordOfTheDayView()
    }
}
