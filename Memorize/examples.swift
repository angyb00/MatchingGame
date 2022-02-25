//
//  examples.swift
//  Memorize
//
//  Created by Angarag Gansukh on 1/2/22.
//

import SwiftUI

struct examples: View {
    @State var num = 0
    var body: some View {
        text
            .onTapGesture {
             num += 1
            }
        
        
            
    }
    
    var text: some View {
        Text("Hello world")
            .rotation3DEffect(Angle.degrees(360), axis: (x: 0, y: 1, z: 0))
            .animation(Animation.easeInOut(duration: 2))
    }
}

struct examples_Previews: PreviewProvider {
    static var previews: some View {
        examples()
    }
}
