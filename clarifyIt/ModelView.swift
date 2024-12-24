import SwiftUI
import Foundation

struct WordLevel: Decodable {
    let meaning: String
    let synonyms: [String]
    let sentence: String
}

struct WordEntry: Decodable {
    let word: String
    let levels: [String: WordLevel]
}

class ModelView: ObservableObject {
    @Published var cards: [Card] = [] // Array to store cards
    @Published var selectedCards: [Card] = [] // To store selected cards

    init() {
        loadWordsFromJSON()
    }

    func loadWordsFromJSON() {
        // Load and decode the JSON from the file
        if let url = Bundle.main.url(forResource: "words", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let dictionary = try? JSONDecoder().decode([String: [WordEntry]].self, from: data) {
            
            // Flatten the words and add them to the cards array
            let allWords = dictionary.values.flatMap { $0 }
            cards = allWords.map { wordEntry in
                Card(value: wordEntry.word)
            }
        } else {
            print("Error loading or decoding JSON")
        }
    }

    func selectCard(_ card: Card) {
        if selectedCards.contains(where: { $0.id == card.id }) {
            selectedCards.removeAll { $0.id == card.id }
        } else {
            selectedCards.append(card)
        }

        if selectedCards.count == 2 {
            matchingCards()
        }
    }

    func matchingCards() {
        guard selectedCards.count == 2 else { return }

        let firstCard = selectedCards[0]
        let secondCard = selectedCards[1]

        if firstCard.value == secondCard.value { // Cards match
            if let firstIndex = cards.firstIndex(where: { $0.id == firstCard.id }),
               let secondIndex = cards.firstIndex(where: { $0.id == secondCard.id }) {

                cards[firstIndex].isMatched = true
                cards[secondIndex].isMatched = true
            }
        } else { // Cards do not match
            if let firstIndex = cards.firstIndex(where: { $0.id == firstCard.id }),
               let secondIndex = cards.firstIndex(where: { $0.id == secondCard.id }) {

                cards[firstIndex].isWrongMatch = true
                cards[secondIndex].isWrongMatch = true

                // Reset the wrong match state after a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.cards[firstIndex].isWrongMatch = false
                    self.cards[secondIndex].isWrongMatch = false
                }
            }
        }

        // Clear the selected cards after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.selectedCards.removeAll()
        }
    }
}

struct Card: Identifiable {
    let id = UUID() // Each card has a unique ID
    let value: String
    var isMatched: Bool = false
    var isWrongMatch: Bool = false
}
