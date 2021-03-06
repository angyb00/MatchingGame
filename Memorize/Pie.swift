//
//  Pie.swift
//  Memorize
//
//  Created by Angarag Gansukh on 12/26/21.
//

import SwiftUI

struct Pie: Shape {
    // no constants as data will change 
    var startAngle: Angle
    var endAngle: Angle
    var clockWise: Bool = true
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        let start = CGPoint(
            x: center.x + radius * CGFloat(cos(startAngle.radians)),
            y: center.y + radius * CGFloat(sin(startAngle.radians))
        )
        
        var p = Path()
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(center: center,
                 radius: radius,
                 startAngle: startAngle,
                 endAngle: endAngle,
                 clockwise: clockWise)
        p.addLine(to: center)
        return p
    }
}
