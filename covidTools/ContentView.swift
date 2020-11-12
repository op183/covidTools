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
    @State var m: CGFloat = 7.0
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
    1531,
    1533,
    1541,
    1542,
    1545,
    1548,
    1552,
    1552,
    1561,
    1562,
    1576,
    1586,
    1587,
    1588,
    1589,
    1607,
    1630,
    1643,
    1657,
    1664,
    1665,
    1667,
    1687,
    1700,
    1720,
    1749,
    1764,
    1765,
    1767,
    1798,
    1851,
    1870,
    1893,
    1901,
    1902,
    1908,
    1927,
    1951,
    1965,
    1976,
    1979,
    1980,
    2021,
    2058,
    2089,
    2118,
    2141,
    2179,
    2181,
    2204,
    2245,
    2265,
    2292,
    2337,
    2344,
    2354,
    2368,
    2417,
    2480,
    2523,
    2566,
    2596,
    2599,
    2615,
    2690,
    2739,
    2801,
    2855,
    2902,
    2907,
    2922,
    3022,
    3102,
    3225,
    3316,
    3356,
    3424,
    3452,
    3536,
    3626,
    3728,
    3842,
    3876,
    3917,
    3989,
    4042,
    4163,
    4300,
    4526,
    4614,
    4636,
    4727,
    4888,
    5066,
    5252,
    5453,
    5532,
    5580,
    5768,
    5860,
    6021,
    6256,
    6546,
    6677,
    6756,
    6931,
    7269,
    7629,
    8048,
    8600,
    9078,
    9343,
    9574,
    10141,
    10938,
    11617,
    12321,
    13139,
    13492,
    13812,
    14689,
    15726,
    16910,
    18797,
    19851,
    20355,
    20886,
    22296,
    24225,
    26300,
    28268,
    29835,
    30695,
    31400,
    33602,
    35330,
    37911,
    40801,
    43843,
    45155,
    46056,
    48943,
    51728,
    55091,
    57664,
    59946,
    61829,
    63556,
    66772,
    68734,
    71088,
    73667,
    75495,
    76072,
    77123,
    79181,
    81772,
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
    101,
    101,
    104,
    105,
    107,
    110,
    114,
    98,
    96,
    91,
    101,
    111,
    112,
    113,
    113,
    131,
    150,
    160,
    174,
    175,
    173,
    175,
    193,
    206,
    226,
    255,
    270,
    271,
    266,
    297,
    346,
    361,
    372,
    380,
    381,
    387,
    392,
    409,
    414,
    425,
    421,
    414,
    455,
    474,
    505,
    513,
    536,
    562,
    537,
    532,
    557,
    562,
    568,
    566,
    573,
    579,
    568,
    611,
    627,
    646,
    674,
    701,
    702,
    710,
    775,
    769,
    826,
    855,
    902,
    907,
    911,
    992,
    1055,
    1147,
    1136,
    1175,
    1238,
    1252,
    1311,
    1387,
    1470,
    1555,
    1565,
    1507,
    1478,
    1486,
    1509,
    1570,
    1692,
    1775,
    1763,
    1777,
    1904,
    2028,
    2134,
    2301,
    2370,
    2413,
    2516,
    2602,
    2694,
    2827,
    2988,
    3090,
    3146,
    3223,
    3340,
    3610,
    3971,
    4458,
    4856,
    5086,
    5200,
    5698,
    6270,
    6807,
    7474,
    8256,
    8572,
    8730,
    9434,
    10316,
    11401,
    13183,
    14159,
    14263,
    14437,
    15521,
    17228,
    19047,
    20889,
    22388,
    23067,
    23298,
    25100,
    26452,
    28918,
    30722,
    33724,
    34860,
    34872,
    36960,
    39301,
    42371,
    44828,
    46929,
    48598,
    49064,
    51037,
    52022,
    53781,
    54962,
    55663,
    55949,
    55015,
    55520,
    56994,
]


