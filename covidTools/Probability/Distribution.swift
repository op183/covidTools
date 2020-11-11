//
//  Distribution.swift
//  covidTools
//
//  Created by Ivo Vacek on 26/05/2020.
//  Copyright © 2020 Ivo Vacek. All rights reserved.
//

import Foundation

protocol DiscreteDistribution {
    var _pmf: [Double] { get set }
    func survival(x: Int) -> Double
}

extension DiscreteDistribution {
    func cdf(x: Int) -> Double {
        1 - survival(x: x)
    }
    
    func pmf(x: Int) -> Double { // probability mass (discrete density)
        if x < _pmf.count {
            return _pmf[x]
        }
        return survival(x: x) - survival(x: x + 1)
    }
    
    func tll(x: Int, lambda: (Int) -> Double = { _ in 1.0}) -> Double {
        var r = 0.0
        //(0 ... x).map { (i) -> Double in
        //    pmf(x: i) * lambda(x - i)
        //}.reduce(into: 0.0) { (r, v) in
        //    r += v
        //}
        //.reduce(0.0, +)
        for i in 0 ... x {
            r += pmf(x: i) * lambda(x - i)
        }
        return r
    }
    
    func tll(x: Int, pmf: (Int) -> Double, lambda: (Int) -> Double = { _ in 1.0}) -> Double {
        //(0 ... x).map { (t) -> Double in
        //    pmf(t) * tll(x: x - t, lambda: lambda)
        //}.reduce(0.0, +)
        var r = 0.0
        for t in 0 ... x {
            r += pmf(t) * tll(x: x - t, lambda: lambda)
        }
        return r
    }
    
    func tllmultiply(x: Int, pmf _pmf: (Int) -> Double, v: Double) -> Double {
        //(0 ... x).map { (t) -> Double in
        //    pmf(x: t) * _pmf(x - t) * v
        //}.reduce(0.0, +)
        var r = 0.0
        for t in 0 ... x {
            r += pmf(x: t) * _pmf(x - t) * v
        }
        return r
    }
    
    func moment(x: Int, n: Int, c: Double = 0.0) -> Double {
        tll(x: x, lambda: { (i) -> Double in
            pow(Double(x - i) - c, Double(n))
        })
    }
}

// GeneralizedDiscreteWeibullDistribution
struct GDWD: DiscreteDistribution {
    let shape: Double
    let scale: Double
    let alpha: Double
    let theta: Double
    let p: Double
    
    var _pmf: [Double] = []
    
    init(shape: Double, scale: Double, alpha: Double, theta: Double, precompute: Int = 1000) {
        self.shape = shape
        self.scale = scale
        self.alpha = alpha
        self.theta = theta
        self.p = exp(-pow(scale, shape))
        self._pmf = (0 ..< precompute).map { (i) -> Double in
            survival(x: i) - survival(x: i + 1)
        }
    }
   
    func survival(x: Int) -> Double {
        guard x >= 0 else { return 1.0 }
        let a = pow(Double(x), shape)
        let b = pow(p, a)
        let c = pow(1 - b, alpha)
        return theta * ( 1 - c) / (theta + (1 - theta) * c)
    }
    
}
