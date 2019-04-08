//
//  main.swift
//  OM_Gradient_Descent
//
//  Created by Иван Романов on 07/04/2019.
//  Copyright © 2019 Иван Романов. All rights reserved.
//

import Foundation

class GradientDescent  {
    let Eps1 = 1e-8, Eps2 = 1e-8, iterationLimit: Int = 10000
    
    var x: [Double]//, Answer: [Double]
    
    
/*+*/func f(arg: [Double]) -> Double {
        let x = arg[0], y = arg[1]
        //return x*x + y*y
        return 5*x*x + y*y - x*y + x
    }
    
    
    func grad(arg: [Double]) -> [Double] {
        let h = Eps1,
        x = arg[0], y = arg[1]
        
        let component1 = (f(arg: [x+h, y]) - f(arg: [x-h, y]))/Double(2.0*h),
            component2 = (f(arg: [x, y+h]) - f(arg: [x, y-h]))/Double(2.0*h)
        
        return [component1, component2]
    }
    
    func v_norm(vector: [Double]) -> Double {
        var summ = 0.0
        for i in vector {
            summ += i*i
        }
        return sqrt(summ)
    }
    
/*!*/func MinCoordinate( function: (Double)->Double ) -> Double { // Golden Ratio
        let φ = (3 - sqrt(5)) / 2
        
        var a = 0.0, b = 1.0,
        
            λ = a + φ*(b-a),
            μ = a + b - λ,
        
            k = 0
        
        repeat {
            k+=1
            
            if function( λ) < function( μ){
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
    
    func v_Substraction(vector1: [Double], vector2: [Double]) -> [Double] {
        var result = [Double]()
        for i in vector1.indices {
            result.append(vector1[i] - vector2[i])
        }
        return result
    }
    
    
    
    
    
    init(initialApproximation: [Double]) {
        x = initialApproximation
        var x_next = x
        var k = 0, min_α: Double,
        predTimeMet = false
        
        
        
        while v_norm(vector : grad(arg: x)) > Eps1 && (k < iterationLimit) {
            
            func g(α: Double)->Double{
                var result = [Double]()
                result.append( x[0] - α*(grad(arg: x)[0]) )
                result.append( x[1] - α*(grad(arg: x)[1]) )
                    
                    
                
                return f(arg: result)
            }
            
            min_α = MinCoordinate(function: g(α:))
            
            for i in x.indices {
                x_next[i] = x[i] - min_α * (grad(arg: x)[i])
            }
            
            if v_norm(vector: v_Substraction(vector1: x_next, vector2: x)) < Eps2
                && fabs(f(arg: x_next) - f(arg: x)) < Eps2 {
                if predTimeMet || k < 1
                    {break}
                else {
                    predTimeMet = true
                }
            }
            
            x = x_next
            k+=1
        }
        
        print(" The answer is \(x)")
        print("k = \(k)")
    }
}

let gradIntance = GradientDescent(initialApproximation: [1.5,1])

