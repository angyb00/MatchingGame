//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Angarag Gansukh on 11/25/21.
//

import SwiftUI

// MARK: ViewModel - serves as the gatekeeper between model and view

// ObservableObject publishes that there are changes
class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    // static makes it global, belongs to the class not instance/objects
    private static var emojis = ["👻", "🎃", "🕷", "🤪", "🥰", "😇", "🥲", "😆", "😂", "🥸", "✈️", "💩"]
    
    private static func createMemoryGame() -> MemoryGame<String> {
        return MemoryGame<String>(numberOfPairsOfCards: 6) { pairIndex in emojis[pairIndex] }
    }
    
    // Other structs and views and can view it but not change it
    // Published will send change notifs anytime model changes
    @Published private(set) var model = createMemoryGame()
    
    // MARK: Only way to expose information from model to views

    var cards: [Card] {
        return model.cards
    }
    
    // MARK: - Intent(s): only way for model to change

    func choose(_ card: Card) {
        model.choose(card)
    }

    func shuffle() {
        model.shuffle()
    }

    func restart() {
        // model changes so @Published will signal that
        model = EmojiMemoryGame.createMemoryGame()
    }
}
