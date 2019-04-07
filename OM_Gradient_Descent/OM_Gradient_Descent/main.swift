//
//  main.swift
//  OM_Gradient_Descent
//
//  Created by Иван Романов on 07/04/2019.
//  Copyright © 2019 Иван Романов. All rights reserved.
//

import Foundation

class GradientDescent  {
    let Eps1 = 1e-3, Eps2 = 1e-3, iterationLimit = 1e3
    
    struct p {
        var x: Double
        var y: Double
    }
    
    var x: Double
    
    init(initialApproximation: Double) {
        x = initialApproximation
    }
    
/*+*/func f(arg: [Double]) -> Double {
        let x = arg[0], y = arg[1]
        return x*x + y*y
    }
    
    
    func grad(arg: [Double]) -> [Double] {
        let h = Eps1,
        x = arg[0], y = arg[1]
        
        let component1 = (f(arg: [x+h, y]) - f(arg: [x-h, y]))/Double(2.0*h),
            component2 = (f(arg: [x, y+h]) - f(arg: [x, y-h]))/Double(2.0*h)
        
        return [component1, component2]
    }
    
    func norm(vector: [Double]) -> Double {
        var summ = 0.0
        for i in vector {
            summ += i*i
        }
        return sqrt(summ)
    }
    
/*!*/func MinCoordinate(x0: Double, f: (Double)->Double ) -> Double { // Golden Ratio
        let φ = (3 - sqrt(5)) / 2
        
        var a = 0.0, b = 1.0,
        
            λ = a + φ*(b-a),
            μ = a + b - λ,
        
            k = 0
        
        repeat {
            k+=1
            
            if f( λ) < f( μ){
                b = μ
                if k%4 == 0 { /// поправка
                    λ = a + φ*(b-a)
                    μ = a + b - λ
                }
                else {
                    μ = λ
                    λ = a + b - μ
                }
            }
            else {
                a = λ
                
                if k%10 == 0 {  /// поправка
                    λ = a + φ*(b-a)
                    μ = a + b - λ
                }
                else{
                    λ = μ
                    μ = a + b - λ
                }
            }
        }
        while fabs(a-b) >= 2*Eps1
        
        return (a + b)/2
    }
    
    func v_Addition(vector1: [Double], vector2: [Double]) -> [Double] {
        var result = [Double]()
        for i in vector1.indices {
            result.append(vector1[i] + vector2[i])
        }
        return result
    }
}

