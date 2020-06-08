//
//  ContentView.swift
//  covidTools
//
//  Created by Ivo Vacek on 26/05/2020.
//  Copyright © 2020 Ivo Vacek. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model = SHIRJA(population: 5500000)
    var dataC: [CGPoint] {
        _sk_rd.enumerated().map { (v) -> CGPoint in
            .init(x: Double(v.offset), y: v.element)
        }
    }
    var dataA: [CGPoint] {
        sk_rd.enumerated().map { (v) -> CGPoint in
            .init(x: Double(v.offset), y: v.element)
        }
    }
    @State var m: CGFloat = 4.7
    var xRange: ClosedRange<CGFloat> {
        0.0 ... CGFloat(model.days)
    }
    var yRange: ClosedRange<CGFloat> {
        0.0 ... pow(5.0,m)
    }
    let g = DragGesture(minimumDistance: 0, coordinateSpace: .global).onEnded({
        print($0.startLocation.x)
    })
    var body: some View {
        VStack {
            Slider(value: $model.days, in: 50.0 ... 730, step: 10.0) {
                HStack {
                    Text("Days")
                    Spacer()
                    Text(String(format: "%d", Int(model.days)))//.frame(width: 200)
                }.frame(width: 200)
            }.padding(.horizontal)
            
            Slider(value: $m, in: 4.0 ... 10.0) {
                HStack {
                    Text("Cases")
                    Spacer()
                    Text(String(format: "%8.f", pow(5.0,m)))
                }.frame(width: 200)
            }.padding(.horizontal)
            
            ZStack {
                Plot(points: model.jt, xRange: xRange, yRange: yRange).stroke(Color.orange, style: StrokeStyle(lineWidth: 1))
                Plot(points: model.ht, xRange: xRange, yRange: yRange).stroke(Color.red, style: StrokeStyle(lineWidth: 1, dash: [3, 3]))
                Plot(points: dataC, xRange: xRange, yRange: yRange).stroke(Color.yellow, style: StrokeStyle(lineWidth: 1))
                Plot(points: model.at, xRange: xRange, yRange: yRange).stroke(Color.blue, style: StrokeStyle(lineWidth: 1))
                Plot(points: model.it, xRange: xRange, yRange: yRange).stroke(Color.orange, style: StrokeStyle(lineWidth: 1, dash: [3, 3]))
                Plot(points: model.rt, xRange: xRange, yRange: yRange).stroke(Color.green, style: StrokeStyle(lineWidth: 1))
                Plot(points: dataA, xRange: xRange, yRange: yRange).stroke(Color.primary, style: StrokeStyle(lineWidth: 1))
                Plot(points: model.lt, xRange: xRange, yRange: 0.0 ... 1.0).stroke(Color.secondary, style: StrokeStyle(lineWidth: 1, dash: [1, 3]))
                }
            .drawingGroup()
            .background(Color.primary.colorInvert().gesture(g)).clipped()
            //.gesture(g)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

let _sk_rd: [Double] = [
    1,
    3,
    5,
    7,
    7,
    10,
    21,
    32,
    44,
    61,
    72,
    96,
    104,
    123,
    137,
    178,
    185,
    204,
    216,
    226,
    269,
    292,
    314,
    336,
    363,
    400,
    426,
    450,
    471,
    485,
    534,
    581,
    682,
    701,
    715,
    728,
    742,
    769,
    835,
    863,
    977,
    1049,
    1089,
    1161,
    1173,
    1199,
    1244,
    1325,
    1360,
    1373,
    1379,
    1381,
    1384,
    1391,
    1396,
    1403,
    1407,
    1408,
    1413,
    1421,
    1429,
    1445,
    1455,
    1455,
    1457,
    1457,
    1465,
    1469,
    1477,
    1480,
    1493,
    1494,
    1495,
    1495,
    1496,
    1502,
    1503,
    1504,
    1509,
    1511,
    1513,
    1515,
    1520,
    1520,
    1521,
    1521,
    1522,
    1522,
    1525,
    1526,
    1526,
    1528,
    1528,
    1530,
]

let sk_rd: [Double] = [
    1,
    3,
    5,
    7,
    7,
    10,
    21,
    32,
    44,
    61,
    72,
    96,
    104,
    122,
    136,
    176,
    183,
    202,
    214,
    224,
    267,
    290,
    312,
    334,
    359,
    396,
    420,
    441,
    462,
    476,
    524,
    566,
    664,
    676,
    690,
    703,
    717,
    660,
    720,
    706,
    802,
    865,
    865,
    920,
    909,
    927,
    946,
    1022,
    988,
    970,
    967,
    960,
    941,
    886,
    849,
    822,
    775,
    765,
    745,
    655,
    642,
    613,
    524,
    510,
    490,
    472,
    455,
    382,
    338,
    322,
    314,
    303,
    282,
    275,
    237,
    229,
    219,
    196,
    180,
    176,
    163,
    160,
    160,
    154,
    137,
    127,
    126,
    122,
    122,
    122,
    119,
    121,
    111,
    106,
]


