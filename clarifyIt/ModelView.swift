import SwiftUI

class ModelView: ObservableObject {
    @Published var cards: [Card] = [] // Array to store cards
    @Published var selectedCards: [Card] = [] // To store selected cards
    @ObservedObject var dataLoader = DataLoader() // Add instance of DataLoader

    init() {
        // Modify to load data from DataLoader
        loadWordsFromDataLoader()
    }

    func loadWordsFromDataLoader() {
        // Use the data from the DataLoader instead of loading directly from JSON
        let allWords = dataLoader.literature + dataLoader.academic + dataLoader.general
        cards = allWords.map { wordEntry in
            Card(value: wordEntry.Word) // Access the 'Word' key from the JSON data
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

// Rename 'Word' to avoid conflicts with other types
struct WordModel: Identifiable, Decodable {  // Renamed 'Word' to 'WordModel'
    let id = UUID()  // Each Word should have a unique identifier
    let Word: String  // Corresponds to the 'Word' key in the JSON data
    let Levels: WordLevels // The 'Levels' object that holds the meanings and synonyms
}

struct WordLevels: Decodable {  // Renamed 'Levels' to 'WordLevels' to avoid ambiguity
    let Low: WordLevelDetail
    let Middle: WordLevelDetail
    let High: WordLevelDetail
}

struct WordLevelDetail: Decodable {
    let Meaning: String
    let Synonyms: [String]
    let Sentence: String
}
