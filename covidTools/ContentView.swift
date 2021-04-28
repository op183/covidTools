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
    @State var m: CGFloat = 7.3
    var xRange: ClosedRange<CGFloat> {
        0.0 ... CGFloat(model.days)
    }
    var yRange: ClosedRange<CGFloat> {
        0.0 ... pow(5.0,m)
    }
    let g = DragGesture(minimumDistance: 0, coordinateSpace: .global).onEnded({
        print($0.startLocation)
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
    83796,
    85567,
    86767,
    87276,
    88602,
    89913,
    91578,
    93396,
    95257,
    96241,
    96472,
    97493,
    99304,
    101257,
    103106,
    104632,
    105733,
    105929,
    107183,
    109226,
    111208,
    113392,
    115462,
    116731,
    117283,
    119232,
    121796,
    124921,
    127087,
    130794,
    132984,
    133489,
    135523,
    139088,
    142133,
    146124,
    149275,
    151336,
    152555,
    155218,
    158905,
    161562,
    165608,
    166649,
    167523,
    168092,
    170187,
    173228,
    179543,
    184508,
    186244,
    187463,
    188099,
    191088,
    196047,
    198184,
    201164,
    205236,
    208209,
    209069,
    211479,
    215055,
    217978,
    220707,
    222752,
    223325,
    224385,
    226294,
    228778,
    231242,
    233027,
    234571,
    236476,
    237027,
    238617,
    241392,
    243427,
    246008,
    248190,
    249913,
    250357,
    252094,
    254826,
    256903,
    259533,
    261774,
    263326,
    264083,
    265807,
    268986,
    271473,
    273904,
    276234,
    277682,
    278254,
    279696,
    282864,
    285419,
    287752,
    290457,
    292143,
    292792,
    294790,
    298337,
    300775,
    303420,
    306268,
    308083,
    308925,
    311002,
    314359,
    317159,
    319582,
    322104,
    323390,
    323786,
    325993,
    329593,
    331571,
    336235,
    337503,
    337960,
    339538,
    342430,
    344470,
    346149,
    347944,
    348869,
    349270,
    350551,
    352528,
    354182,
    355454,
    356985,
    357910,
    358115,
    359330,
    361185,
    362489,
    363874,
    364622,
    365242,
    365400,
    365733,
    366894,
    368470,
    369393,
    370473,
    371062,
    371168,
    372038,
    373107,
    373950,
    374586,
    375336,
    375974,
    376067,
    376709,
    377473,
    378150,
    378635,
    379476,
    379911,
    380010,
    380498,
    381180,
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
    56866,
    56033,
    55738,
    55697,
    54139,
    53410,
    52304,
    51966,
    51425,
    49687,
    47846,
    46046,
    45025,
    44130,
    43050,
    41740,
    40720,
    39049,
    37456,
    36590,
    36005,
    35293,
    34525,
    33069,
    31415,
    30753,
    30943,
    32362,
    32432,
    34230,
    34741,
    33699,
    33969,
    36195,
    38018,
    40124,
    41404,
    41953,
    41130,
    43035,
    44592,
    45563,
    48213,
    47969,
    46664,
    45803,
    46444,
    46736,
    51434,
    55068,
    55709,
    55152,
    54681,
    55633,
    57630,
    57084,
    56886,
    0,//57788,
    0,//58016,
    0,//55823,
    0,//54622,
    0,//54864,
    0,//54317,
    0,//54022,
    0,//52780,
    0,//50936,
    0,//49767,
    0,//48896,
    0,//48177,
    0,//46312,
    0,//45191,
    0,//43923,
    0,//42449,
    0,//39579,
    0,//37166,
    0,//34883,
    0,//33769,
    0,//33107,
    0,//31354,
    0,//29219,
    0,//26723,
    0,//24668,
    0,//23466,
    0,//21471,
    0,//20112,
    0,//18418,
    0,//16441,
    0,//13110,
    0,//12039,
    0,//11866,
    0,//12326,
    0,//273904 - 255300 - 5733,
    0,//276234 - 255300 - 5812,
    0,//277682 - 255300 - 5885,
    0,//278254 - 255300 - 5952,
    0,//279696 - 255300 - 6063,
    0,//282864 - 255300 - 6168, /* 333977*/
    0,//285419 - 255300 - 6271,
    0,//287752 - 255300 - 6350,
    0,//290457 - 255300 - 6424,
    0,//292143 - 255300 - 6505,
    0,//292792 - 255300 - 6577,
    0,//294790 - 255300 - 6671,
    0,//298337 - 255300 - 6775, // 62986,
    0,//300775 - 255300 - 6859,
    0,//303420 - 255300 - 6966,
    0,//306268 - 255300 - 7075,
    0,//308083 - 255300 - 7189,
    0,//308925 - 255300 - 7270,
    0,//311002 - 255300 - 7388,
    0,//314359 - 255300 - 7489, // 44662
    0,//317159 - 255300 - 7560 - 44662/7,
    0,//319582 - 255300 - 7665 - 44662/7,
    0,//322104 - 255300 - 7739 - 44662/7,
    0,//323390 - 255300 - 7836 - 44662/7,
    0,//323786 - 255300 - 7921 - 44662/7,
    0,//325993 - 255300 - 8037 - 44662/7,
    0,//329593 - 255300 - 8146 - 37114/7,
    0,//331571 - 255300 - 8244 - 37114/7,
    0,//336235 - 255300 - 8440 - 37114/7,
    0,//337503 - 255300 - 8528 - 37114/7,
    0,//337960 - 255300 - 8605 - 37114/7,
    0,//339538 - 255300 - 8669 - 37114/7,
    0,//342430 - 255300 - 8738 - 36302/7,
    0,//344470 - 255300 - 8814 - 36302/7,
    0,//346149 - 255300 - 8894 - 36302/7,
    0,//347944 - 255300 - 8978 - 36302/7,
    0,//348869 - 255300 - 9044 - 36302/7,
    0,//349270 - 255300 - 9104 - 36302/7,
    0,//350551 - 255300 - 9190 - 36302/7,
    0,//352528 - 255300 - 9261 - 38063/7,
    0,//354182 - 255300 - 9313 - 38063/7,
    0,//355454 - 255300 - 9373 - 38063/7,
    0,//356985 - 255300 - 9426 - 38063/7,
    0,//357910 - 255300 - 9496 - 38063/7,
    0,//358115 - 255300 - 9542 - 38063/7,
    0,//359330 - 255300 - 9624 - 38063/7,
    0,//361185 - 255300 - 9719 - 34536/7,
    0,//362489 - 255300 - 9790 - 34536/7,
    0,//363874 - 255300 - 9877 - 34536/7,
    0,//364622 - 255300 - 9948 - 34536/7,
    0,//365242 - 255300 - 10025 - 34536/7,
    0,//365400 - 255300 - 10094 - 34536/7,
    0,//365733 - 255300 - 10156 - 34536/7,
    0,//366894 - 255300 - 10243 - 34536/7,
    0,//368470 - 255300 - 10322 - 34536/7,
    0,//369393 - 255300 - 10411 - 34536/7,
    0,//370473 - 255300 - 10487 - 34536/7,
    0,//371062 - 255300 - 10565 - 21758/7,
    0,//371168 - 255300 - 10630 - 21758/7,
    0,//372038 - 255300 - 10716 - 21758/7,
    0,//373107 - 255300 - 10798 - 21498/7,
    0,//373950 - 255300 - 10798 - 21498/7,
    0,//374586 - 255300 - 10970 - 21498/7,
    0,//375336 - 255300 - 11043 - 21498/7,
    0,//375974 - 255300 - 11106 - 21498/7,
    0,//376067 - 255300 - 11172 - 21498/7,
    0,//376709 - 255300 - 11244 - 21498/7,
    0,//377473 - 255300 - 11304 - 21498/7,
    0,//378150 - 255300 - 11357 - 17821/7,
    0,//378635 - 255300 - 11405 - 17821/7,
    0,//379476 - 255300 - 11458 - 17821/7,
    0,//379911 - 255300 - 11495 - 17821/7,
    0,//380010 - 255300 - 11531 - 17821/7,
    0,//380498 - 255300 - 11572 - 17821/7,
    0,//381180 - 255300 - 11611 - 17821/7,
    10000000,
]


