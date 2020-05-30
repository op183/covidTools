//
//  Model.swift
//  covidTools
//
//  Created by Ivo Vacek on 26/05/2020.
//  Copyright © 2020 Ivo Vacek. All rights reserved.
//

import Foundation
import Combine

class SHIRJA: ObservableObject {
    // model parameters
    @Published var beta = 0.24
    @Published var lambda = 0.28

    @Published var eta = 0.6
    @Published var hiddenInfectious: Double = 1.0
    @Published var days: Double = 300.0
    
    @Published var refDay: Int = 26
    
    let N: Double   // population
    var handle: AnyCancellable? = nil
    
    init(population: Double) {
        N = population
        
        handle = objectWillChange.sink {
            self.solve()
        }
        
        defer {
            solve()
        }
    }
    
    func betaf(x: Int, intervention: [Int: Double], dist: DiscreteDistribution) -> Double {
        guard intervention.isEmpty == false else { return beta }
        let intp = intervention.sorted { (a, b) -> Bool in
            a.key > b.key
        }
        let v = intp.first { (element) -> Bool in
            element.key <= x
        }?.key ?? 0
        
        let to = intervention[v] ?? 1.0
        
        let u = intp.first { (element) -> Bool in
            element.key < v
        }?.key ?? 0
        
        let from = intervention[u] ?? 1.0
        if from == to {
            return beta * from
        }
        
        let p = dist.survival(x: x - v)
        
        return (p * from + (1 - p) * to) * beta
    }
    
    var st: [CGPoint] = []
    var ht: [CGPoint] = []
    var it: [CGPoint] = []
    var rt: [CGPoint] = []
    var jt: [CGPoint] = []
    var at: [CGPoint] = []
    var lt: [CGPoint] = []

    
    // fixed covid-19 probability parameters (based on statistical data)
    let gdwd1 = GDWD(shape: 2.04, scale: 0.103, alpha: 1, theta: 1)
    let gdwd2 = GDWD(shape: 3.8, scale: 0.0617, alpha: 2.3, theta: 1)
    let gdwd3 = GDWD(shape: 3.8, scale: 0.07, alpha: 1.8, theta: 0.5)
    let gdwd4 = GDWD(shape: 3.8, scale: 0.3, alpha: 1.4, theta: 1)
    let gdwd5 = GDWD(shape: 8, scale: 1 / 25, alpha: 2, theta: 1)
    //let gdwd5 = GDWD(shape: 3.8, scale: 0.057, alpha: 52, theta: 1)

    // fixed mobility change dynamics (exponential, 3 days)
    let betad = GDWD(shape: 1, scale: 1 / 2, alpha: 1, theta: 1)
    
    func solve() {
        //let start = Date()
        // reset
        var S = [1.0]
        var H = [hiddenInfectious / N]
        var I = [eta * H[0]]
        var R = [0.0]
        var J = [0.5 / N]
        var A = [0.0]
        var B: [Double] = []
        var L: [Double] = []
        //S.reserveCapacity(1000)
        //H.reserveCapacity(1000)
        //I.reserveCapacity(1000)
        //R.reserveCapacity(1000)
        //J.reserveCapacity(1000)
        //A.reserveCapacity(1000)
        //B.reserveCapacity(1000)
        //L.reserveCapacity(1000)

        (0 ..< Int(days) + refDay).forEach { (i) in
            let l = betaf(x: i, intervention: [
                refDay + 6:0.48,        // zaciatok opatreni
                refDay + 10:0.445,      // mimoriadny stav + maloobchod
                refDay + 19:0.435,      // rúška
                refDay + 32:0.203,      // povinna karantena + curfew
                refDay + 39:0.205,      // - curfew
                refDay + 47:0.2,        // prva faza uvolnenia
                refDay + 61:0.35,       // druha a tretia faza uvolnenia
                refDay + 75:0.4,        // stvrta faza uvolnenia

            ], dist: betad)
            let b = S[i] * H[i] * l
            B.append(b)
            L.append(l)
            
            let h1 =  (1 - eta) * gdwd1.tll(x: i, lambda: { (i) -> Double in
                B[i]
            })
            let h2 = eta * gdwd3.tll(x: i) { (i) -> Double in
                B[i]
            }
            let h3 = (1 - eta) * gdwd1.pmf(x: i) * H[0]
            let h4 = eta * gdwd3.pmf(x: i) * H[0]
            
            let i1 = h1
            let i2 = (1 - eta) * gdwd1.tll(x: i, pmf: gdwd2.pmf(x:)) { (i) -> Double in
                B[i]
            }
            let i3 = h3
            let i4 = (1 - eta) * gdwd2.tllmultiply(x: i, pmf: gdwd1.pmf(x:), v: H[0])
            let i5 = gdwd2.pmf(x: i) * I[0]
            
            let r1 = h2
            let r2 = i2
            let r3 = h4
            let r4 = i4
            let r5 = i5
            
            let j1 = (1 - eta) * gdwd1.tll(x: i, pmf: gdwd4.pmf(x:), lambda: { (i) -> Double in
                B[i]
            })
            let j2 = (1 - eta) * gdwd4.tllmultiply(x: i, pmf: gdwd1.pmf(x:), v: H[0])
            
            let a1 = gdwd5.tll(x: i) { (i) -> Double in
                J[i]
            }
            
            S.append(S[i] - b)
            H.append(H[i] + b - h1 - h2 - h3 - h4)
            I.append(I[i] + i1 - i2 + i3 - i4 - i5)
            R.append(R[i] + r1 + r2 + r3 + r4 + r5)
            J.append(J[i] + j1 + j2)
            A.append(J[i] - a1)
            
            let corr = S[i] + H[i] + I[i] + R[i]

            S[i] /= corr
            H[i] /= corr
            I[i] /= corr
            R[i] /= corr
            J[i] /= corr
            
        }
        st = S[refDay...].map{$0}.enumerated().map({ (v) -> CGPoint in
            .init(x: Double(v.offset), y: v.element * N)
        })
        ht = H[refDay...].map{$0}.enumerated().map({ (v) -> CGPoint in
            .init(x: Double(v.offset), y: v.element * N)
        })
        it = I[refDay...].map{$0}.enumerated().map({ (v) -> CGPoint in
            .init(x: Double(v.offset), y: v.element * N)
        })
        rt = R[refDay...].map{$0}.enumerated().map({ (v) -> CGPoint in
            .init(x: Double(v.offset), y: v.element * N)
        })
        jt = J[refDay...].map{$0}.enumerated().map({ (v) -> CGPoint in
            .init(x: Double(v.offset), y: v.element * N)
        })
        at = A[refDay...].map{$0}.enumerated().map({ (v) -> CGPoint in
            .init(x: Double(v.offset), y: v.element * N)
        })
        
        lt = L[refDay...].map{$0}.enumerated().map({ (v) -> CGPoint in
            .init(x: Double(v.offset), y: v.element / beta)
        })
        
        //let stop = Date()
        //print(stop.distance(to: start))
    }
}