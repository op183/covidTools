//
//  Plot.swift
//  covidTools
//
//  Created by Ivo Vacek on 26/05/2020.
//  Copyright © 2020 Ivo Vacek. All rights reserved.
//

import SwiftUI


struct Plot: Shape {
    let points: [CGPoint]
    let xRange: ClosedRange<CGFloat>
    let yRange: ClosedRange<CGFloat>
    
    func path(in rect: CGRect) -> Path {
        let xs = (xRange.upperBound - xRange.lowerBound) / rect.width
        let ys = (yRange.upperBound - yRange.lowerBound) / rect.height
        let p = points.map { (cgp) -> CGPoint in
            .init(x: (cgp.x - xRange.lowerBound) / xs, y: rect.height - (cgp.y - yRange.lowerBound) / ys)
        }
        return Path { (path) in
            guard p.count > 0 else { return }
            path.move(to: p[0])
            for i in 0 ..< p.count where i > 0 {
                path.addLine(to: p[i])
            }
        }
    }
}
