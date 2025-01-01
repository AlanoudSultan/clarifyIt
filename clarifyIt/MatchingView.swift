import SwiftUI

struct MatchingView: View {
    @State private var currentIndex: Int = 0
    @State private var wordSentencePairs: [(word: String, sentence: String)] = [
        ("Melancholy", "Feeling very sad, but you don’t know exactly why. It’s a kind of quiet sadness that stays with you for a while."),
        ("Euphoria", "Feeling very, very happy, like the best feeling ever. It’s when you feel so good, nothing can make you sad."),
        ("Serenity", "feeling very calm and peaceful. It’s like when everything is quiet, and you feel good inside.")
    ]
    @State private var selectedWord: String? = nil
    @State private var answerStatus: [Int: String?] = [:]
    
    @State private var remainingTime: Int = 60
    @State private var timer: Timer? = nil
    @State private var totalTime: Int = 60
    @State private var showAlert: Bool = false
    
    // Start the countdown timer
    func startTimer() {
        timer?.invalidate()
        remainingTime = totalTime
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                timer?.invalidate()
                showAlert = true
            }
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.purpleMatch.opacity(0.2), lineWidth: 10)
                        .frame(width: 60, height: 60)
                    
                    Circle()
                        .trim(from: 0.0, to: CGFloat(remainingTime) / CGFloat(totalTime))
                        .stroke(Color.purpleMatch, lineWidth: 10)
                        .rotationEffect(.degrees(-90))
                        .frame(width: 60, height: 60)
                    
                    Text("\(remainingTime)")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(remainingTime > 10 ? .purpleMatch : .red)
                        .frame(width: 60, height: 60)
                }
                .padding(.top, 20)
                .padding(.trailing, 20)
            }
            
            // Box for the sentence at the top
            TabView(selection: $currentIndex) {
                ForEach(wordSentencePairs.indices, id: \.self) { index in
                    VStack {
                        Text(wordSentencePairs[index].sentence)
                            .font(.system(size: 18, weight: .medium))
                            .multilineTextAlignment(.center)
                            .frame(width: UIScreen.main.bounds.width - 50, height: 214)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.purpleMatch, lineWidth: 5)
                            )
                            .padding(.top, 30)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .padding(.horizontal, 20)
            .onChange(of: currentIndex) { newIndex in
                answerStatus[newIndex] = nil
            }

            // Dots Indicator (Progress Bar)
            HStack {
                ForEach(0..<wordSentencePairs.count, id: \.self) { index in
                    Circle()
                        .fill(currentIndex == index ? Color.purple1 : Color.gray7)
                        .frame(width: 10, height: 10)
                        .onTapGesture {
                            if answerStatus[currentIndex] == nil {  // Only allow navigating if no answer selected
                                currentIndex = index
                            }
                        }
                }
            }
            .background(Color.gray.opacity(0.1))
            .edgesIgnoringSafeArea(.all)
            .padding(10)

            Spacer()

            // Box for options in a vertical stack
            VStack(spacing: 20) {
                ForEach(wordSentencePairs, id: \.word) { pair in
                    VStack {
                        Text(pair.word)
                            .font(.system(size: 24, weight: .medium))
                            .multilineTextAlignment(.center)
                            .frame(width: UIScreen.main.bounds.width - 40, height: 80)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(answerStatus[currentIndex] == pair.word ? (pair.word == wordSentencePairs[currentIndex].word ? Color.green : Color.red) : Color.purpleMatch, lineWidth: 2)
                            )
                            .cornerRadius(12)
                            .padding(.horizontal)
                            .onTapGesture {
                                if answerStatus[currentIndex] == nil {
                                    answerStatus[currentIndex] = pair.word
                                }
                            }
                    }
                }
            }
            .padding(.bottom, 50)

            // Show buttons only after the last question is answered
            if currentIndex == wordSentencePairs.count - 1 && answerStatus[currentIndex] != nil {

                HStack {
                    // Button for "Try Again"
                    Button(action: {
                        currentIndex = 0
                        answerStatus = [:]
                        startTimer()
                    }) {
                        Text("Try Again")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: UIScreen.main.bounds.width / 2.5, height: 50)
                            .background(Color.purpleMatch)
                            .cornerRadius(12)
                    }
                    .padding(.leading, 10)
                    
                    Spacer()
                    
                    // Button for "Done"
                    // change ContentView To MainView
                    NavigationLink(destination: ContentView()) {
                        Text("Done")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.purpleMatch)
                            .padding()
                            .frame(width: UIScreen.main.bounds.width / 2.5, height: 50)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.purpleMatch, lineWidth: 1.5)
                            )
                    }
                
                    .padding(.trailing, 20)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            startTimer()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Time is up!"),
                message: Text("The time for this test has finished."),
                dismissButton: .default(Text("Try Again"), action: {
                    currentIndex = 0
                    answerStatus = [:]
                    startTimer()
                })
            )
        }
                
    }
                
}




struct MatchingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MatchingView()
        }
    }
}
