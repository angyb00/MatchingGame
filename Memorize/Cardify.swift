//
//  Cardify.swift
//  Memorize
//
//  Created by Angarag Gansukh on 12/29/21.
//

import SwiftUI

struct Cardify: AnimatableModifier {

    var rotation: Double //Degrees

    // the Shape protocol inherits from Animatable
    // and this var is the only thing in Animatable
    // so by implementing it to get/set our pair of angles
    // we are thus animatable
    var animatableData: Double {
        get{rotation}
        set{rotation = newValue}
    }
    
    init(isFaceUp: Bool){
        rotation = isFaceUp ? 0:180
    }
    
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstant.cornerRadius)
            if rotation < 90 {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstant.lineWidth)
                
            } else {
                shape.fill()
            }
            content     //Put content here to spin both cards
                .opacity(rotation < 90 ? 1 : 0)
        }
        //Spin 180 around y-axis (x: 0, y: 1, z: 0)
        .rotation3DEffect(Angle.degrees(rotation), axis: (0,1,0))
    }
    
    private struct DrawingConstant {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
    }
}

//MARK: Creating our own ViewModifier/Syntactic sugar
extension View {
    
    func cardify(isFaceUp: Bool) -> some View {
        modifier(Cardify(isFaceUp: isFaceUp))
    }
}
