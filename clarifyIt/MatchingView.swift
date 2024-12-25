
import SwiftUI

struct MatchingView: View {
    @State private var wordSentencePairs: [(word: String, sentence: String, isMatched: Bool, isDisabled: Bool)] = []
    @State private var shuffledSentences: [String] = [] // Shuffled sentences
    @State private var selectedWord: String? = nil
    @State private var selectedSentence: String? = nil
    @State private var progress: CGFloat = 0.0
    @State private var correctMatch: Bool? = nil // Track correctness of the match
    @ObservedObject var modelView = ModelView() // Use ModelView to handle data and logic

    var body: some View {
        NavigationView {
            VStack {
                renderNavigationAndProgressBar()

                // Title Text
                renderTitle()

                // Matching Pairs UI
                renderMatchingPairs()

                // Check Button
                renderCheckButton()
            }
            .onAppear {
                loadWordSentencePairs()
                shuffleSentences()
            }
            .background(Color.white)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true) // Hide default back button to use custom button
        }
    }

    private func renderNavigationAndProgressBar() -> some View {
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
                    .fill(Color.green2.opacity(0.2))
                    .frame(width: UIScreen.main.bounds.width - 90, height: 10)

                Capsule()
                    .fill(Color.green2)
                    .frame(width: (UIScreen.main.bounds.width - 90) * progress, height: 10)
            }
        }
        .padding()
        .padding(.top, 20)
    }

    private func renderTitle() -> some View {
        Text("Match the word with the right sentence")
            .font(.system(size: 24, weight: .medium))
            .multilineTextAlignment(.center)
            .frame(width: 260, height: 60)
            .padding()
    }

    private func renderMatchingPairs() -> some View {
        VStack(spacing: 20) {
            ForEach(wordSentencePairs.indices, id: \Int.self) { index in
                renderPair(index: index)
            }
        }
        .padding()
    }

    private func renderPair(index: Int) -> some View {
        HStack(spacing: 20) {
            // Word Box
            Text(wordSentencePairs[index].word)
                .font(.system(size: 24, weight: .medium))
                .multilineTextAlignment(.center)
                .frame(width: UIScreen.main.bounds.width - 250, height: 150)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            wordSentencePairs[index].isDisabled ? Color.gray : (wordSentencePairs[index].isMatched ? Color.green : getStrokeColor(for: wordSentencePairs[index].word, isWord: true)),
                            lineWidth: wordSentencePairs[index].isMatched || wordSentencePairs[index].isDisabled ? 7 : (selectedWord == wordSentencePairs[index].word ? 7 : 1)
                        )
                )
                .onTapGesture {
                    if !wordSentencePairs[index].isDisabled {
                        selectedWord = (selectedWord == wordSentencePairs[index].word) ? nil : wordSentencePairs[index].word
                    }
                }

            // Sentence Box
            Text(shuffledSentences[index])
                .font(.system(size: 13, weight: .medium))
                .multilineTextAlignment(.leading)
                .padding(.leading, 10.0)
                .lineSpacing(3)
                .frame(width: UIScreen.main.bounds.width - 250, height: 150)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            wordSentencePairs.first(where: { $0.sentence == shuffledSentences[index] })?.isDisabled == true ? Color.gray : (wordSentencePairs.first(where: { $0.sentence == shuffledSentences[index] })?.isMatched == true ? Color.green : getStrokeColor(for: shuffledSentences[index], isWord: false)),
                            lineWidth: wordSentencePairs.first(where: { $0.sentence == shuffledSentences[index] })?.isMatched == true || wordSentencePairs.first(where: { $0.sentence == shuffledSentences[index] })?.isDisabled == true ? 7 : (selectedSentence == shuffledSentences[index] ? 7 : 1)
                        )
                )
                .onTapGesture {
                    if let pair = wordSentencePairs.first(where: { $0.sentence == shuffledSentences[index] }), !pair.isDisabled {
                        selectedSentence = (selectedSentence == shuffledSentences[index]) ? nil : shuffledSentences[index]
                    }
                }
        }
    }

    private func renderCheckButton() -> some View {
        Button(action: {
            if let word = selectedWord, let sentence = selectedSentence {
                checkMatch(word: word, sentence: sentence)
            }
        }) {
            Text("Check")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor((selectedWord != nil && selectedSentence != nil) ?  Color.white : Color.gray)
                .frame(maxWidth: UIScreen.main.bounds.width - 70 , minHeight: 66)
                .background((selectedWord != nil && selectedSentence != nil) ?  Color("PurpleMatch") : Color("Gray 2"))
                .cornerRadius(12)
        }
        .disabled(selectedWord == nil || selectedSentence == nil)
        .padding()
    }

    private func loadWordSentencePairs() {
        let level = "Low" // Example level; replace with dynamic logic
        wordSentencePairs = modelView.dataLoader.literature.map { word in
            (word.Word, word.Levels.Low.Meaning, false, false) // Add isDisabled flag
        }.prefix(3).map { $0 } // Limit to 3 pairs
    }

    private func shuffleSentences() {
        shuffledSentences = wordSentencePairs.map { $0.sentence }.shuffled()
    }

    private func checkMatch(word: String, sentence: String) {
        if let pairIndex = wordSentencePairs.firstIndex(where: { $0.word == word && $0.sentence == sentence }) {
            // Correct Match
            correctMatch = true
            progress += 1 / CGFloat(wordSentencePairs.count)
            wordSentencePairs[pairIndex].isMatched = true

            // Disable the matched pair after green transition
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                wordSentencePairs[pairIndex].isMatched = false
                wordSentencePairs[pairIndex].isDisabled = true
                selectedWord = nil
                selectedSentence = nil
                correctMatch = nil
            }
        } else {
            // Wrong Match
            correctMatch = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                selectedWord = nil
                selectedSentence = nil
                correctMatch = nil
            }
        }
    }

    private func getStrokeColor(for value: String, isWord: Bool) -> Color {
        if isWord {
            if selectedWord == value && correctMatch == true {
                return Color.green
            } else if selectedWord == value && correctMatch == false {
                return Color.red
            } else if selectedWord == value {
                return Color("PurpleMatch")
            }
        } else {
            if selectedSentence == value && correctMatch == true {
                return Color.green
            } else if selectedSentence == value && correctMatch == false {
                return Color.red
            } else if selectedSentence == value {
                return Color("PurpleMatch")
            }
        }
        return Color.gray
    }
}

struct MatchingView_Previews: PreviewProvider {
    static var previews: some View {
        MatchingView()
    }
}
