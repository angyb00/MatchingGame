//
//  MemorizeApp.swift
//  Memorize
//
//  Created by oyunbat tovuudorj on 10/13/21.
//

import SwiftUI

@main
struct MemorizeApp: App {
    
    private let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
