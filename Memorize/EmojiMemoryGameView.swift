//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by oyunbat tovuudorj on 10/13/21.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    // ObservedObject rebuilds body if viewModel posts any changes
    // Set is an array with no duplicate items
    @ObservedObject var game: EmojiMemoryGame
    @State private var dealt = Set<Int>()
    @Namespace private var dealingNamespace

    var body: some View {
        ZStack(alignment: .bottom){
        VStack {
            gameBody
            HStack {
                restart
                Spacer()
                shuffle
            }.padding(.horizontal)
        }
         deckBody
        }.padding()
    }
    
    //MatchedGeometryEffect helps with transition
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2 / 3) { card in
            if isUndealt(card) || (card.isMatched && !card.isFaceUp) {
                Color.clear
            }
            else {  //includes animation when cards are matched
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .opacity)) // .identity does nothing
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 1)) {
                            game.choose(card)
                        }
                    }
            }

        }.foregroundColor(CardConstants.color)
    }

    //Includes animation to deal out cards
    //ForEach causes view to change so it will trigger animation
    var deckBody: some View {
        ZStack { // filter changes the cards so transition removal will work
            ForEach(game.cards.filter(isUndealt)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .zIndex(zIndex(of: card))
            }
        }.frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
            .foregroundColor(CardConstants.color)
            .onTapGesture {
                for card in game.cards {
                    withAnimation(dealAnimation(for: card)) {
                        deal(card)
                    }
                }
            }
    }

    var shuffle: some View {
        Button("Shuffle") {
            withAnimation {
                game.shuffle()
            }
        }
    }

    var restart: some View {
        Button("restart") {
            withAnimation {
                // Changing dealt will trigger an animation
                dealt = []
                game.restart()
            }
        }
    }

    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (CardConstants.dealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }

    //Deal out the cards from the top
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }

    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }

    private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
        return !dealt.contains(card.id)
    }

    private enum CardConstants {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2 / 3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
}

struct CardView: View {
    let card: EmojiMemoryGame.Card

    //This will contain the matching animation(implicit animation)
    //Once card.isMatched changes it will trigger animation of spinning emojis
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 110-90)).padding(5).opacity(0.5)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(Animation.linear(duration: 3).repeatForever(autoreverses: false))
                    .font(Font.system(size: DrawingConstant.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
            }.cardify(isFaceUp: card.isFaceUp)
        }
    }

    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstant.fontSize / DrawingConstant.fontScale)
    }

    private enum DrawingConstant {
        static let fontScale: CGFloat = 0.70
        static let fontSize: CGFloat = 32
    }
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards.first!)
        return EmojiMemoryGameView(game: game).preferredColorScheme(.dark)
        // EmojiMemoryGameView(game: game).preferredColorScheme(.light)
    }
}
