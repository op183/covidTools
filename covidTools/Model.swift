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
    @Published var beta = 0.2442//0.2401
    
    //@Published var lambda = 0.28

    @Published var eta = 0.589//0.5840 //0.6
    @Published var hiddenInfectious: Double = 1.0
    @Published var days: Double = 360.0
    
    @Published var refDay: Int = 25
    
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

    // fixed mobility change dynamics (exponential, 2 days)
    let betad = GDWD(shape: 1, scale: 1 / 2, alpha: 1, theta: 1)
    
    func solve() {
       
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
                // deň:vplyv_opatrení_a_reakcia_populácie (miera sociálnych interakcií v popilácii) [0 ... 1]
                refDay + 6:0.48,        // zaciatok opatreni
                refDay + 10:0.445,      // mimoriadny stav + maloobchod
                refDay + 19:0.435,      // rúška
                refDay + 32:0.2,      // povinna karantena + curfew
                refDay + 39:0.202,      // - curfew
                refDay + 47:0.215,        // prva faza uvolnenia
                refDay + 61:0.23,       // druha a tretia faza uvolnenia
                refDay + 75:0.33,        // stvrta faza uvolnenia
                refDay + 90:0.8,        // piata faza uvolnenia ??
                
                refDay + 100:0.7,
                refDay + 110:0.5,
                refDay + 120:0.3,
                refDay + 130:0.479,
                
                refDay + 185:0.63, // dosiahli sme limit vyhladavania .... ???!!

                refDay + 210:0.48, // hromadne podujatia limitované
                refDay + 220:0.43, // hromadné podujatia, reštaurácie, fitness
                
                refDay + 231:0.39, //0.39, // lockdown + plošné testovanie (Orava, Bardejov ...) ???????
                
                refDay + 238:0.08, // lockdown + plošné testovanie (plošné) ???????
                refDay + 240:0.36, //0.36, // lockdown + plošné testovanie (plošné) ???????

                refDay + 245:0.15, // plošné testovanie (limitované len pre sever, čo je totálny fail!!) ???????
                refDay + 247:0.36, // plošné testovanie (limitované len pre sever, čo je totálny fail!!) ???????

                refDay + 255:0.46, // partial easing, balanced Rt ≈ 1,1
                refDay + 258:0.49,
                
                refDay + 260:0.35,  // "mass" testing 4th in row (500 MOM >1%), almost for nothing!!!
                refDay + 262:0.58,  // revised Rt ≈ 1,2 ??? // balanced Rt ≈ 1,34 (semms to be too optimistic ?, will see in few days)
                
                refDay + 265:0.51,
                refDay + 270:0.47,
                
                refDay + 286:0.39, // lockdown + curfew
                refDay + 301:0.35, // lockdown + curfew
                
                //refDay + 318:0.15,
                refDay + 322:0.1,
                refDay + 326:0.07,
                refDay + 331:0.45, // ???

            ], dist: betad)
            let b = S[i] * H[i] * l
            B.append(b)
            L.append(l)
            
            let h1 =  (1 - eta) * gdwd1.tll(x: i, lambda: { (i) -> Double in
                B[i]
            })
            let h2 = eta * gdwd3.tll(x: i, lambda: { (i) -> Double in
                B[i]
            })
            //let h2 = eta * gdwd3.tll(x: i) { (i) -> Double in
            //    B[i]
            //}
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
            
            let a1 = gdwd5.tll(x: i, lambda: { (i) -> Double in
                J[i]
            })
            //let a1 = gdwd5.tll(x: i) { (i) -> Double in
            //    J[i]
            //}
            
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
        
    }
}
