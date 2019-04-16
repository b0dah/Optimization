//
//  main.swift
//  OM_Gradient_Descent
//
//  Created by Иван Романов on 07/04/2019.
//  Copyright © 2019 Иван Романов. All rights reserved.
//

import Foundation

class GradientDescent  {
    let Eps1 = 1e-7, Eps2 = 1e-7, iterationLimit: Int = 1000
    
    //var x: [Double]
    
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
        let loc_eps = 1e-12
        
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
        while fabs(a-b) >= 2*loc_eps//Eps1
        
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
    
    func solve(x0: [Double] ) {
        var x=x0, x_next = x0,
        k = 0, min_α: Double,
        predTimeMet = false
        
        
        
        while v_norm(vector : grad(arg: x)) > Eps1 && (k < iterationLimit) {
            ///////////////////////////////////////////////////
            func g(α: Double)->Double{
                var result = [Double]()
                result.append( x[0] - α*(grad(arg: x)[0]) )
                result.append( x[1] - α*(grad(arg: x)[1]) )
                
                
                
                return f(arg: result)
            }
            
            min_α = MinCoordinate(function: g(α:))
            ///////////////////////////////////////////
            
            
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
            else {
                predTimeMet = false
            }
            
            x = x_next
            k+=1
        }
        
        print("  min  ->  \(x))")
        print("k = \(k)")
        print()
    }
    
    
    init(initialApproximation: [Double]) {
        //print("      || Gradient descent: ||")
        solve(x0: initialApproximation)
    }
}

class FletcherRivesMethod: GradientDescent {
    
    override func MinCoordinate(function: (Double) -> Double) -> Double {
        
            let eps = 1e-12;
            let delta = 1e-3
            
            var a = 0.0, b = 1.0, c: Double = 0.0;
            
            while fabs(b - a) > eps {
                c = (a + b) / Double(2);
                
                if function( c-delta) < function( c+delta) {
                    b = c;
                }
                else {
                    a = c;
                }
            }
            print(" min = " , (a + b) / Double(2) )
            return (a + b) / 2
        }
    
    override func solve(x0: [Double]) {
        var x=x0, x_next = x0, x_pred = x0,
            k = 0, min_α: Double,
            predTimeMet = false,
            S: [Double],  B: Double;
        
        // Init S
            S = [ -(grad(arg: x)[0]), -(grad(arg: x)[1]) ]
            
        while v_norm(vector : grad(arg: x)) > Eps1 && (k < iterationLimit) {
                    print("norm =", v_norm(vector : grad(arg: x)))
            //recomputing S
            if k>0 {
                B = (v_norm(vector: grad(arg: x)) * v_norm(vector: grad(arg: x)) ) / Double( (v_norm(vector: grad(arg: x_pred)) * v_norm(vector: grad(arg: x_pred)) ) )
                print("B=", B)
                /*S*/
                for i in x.indices {
                    S[i] = -grad(arg: x)[i] + B * S[i]
                }
            }
            ////////////////////////////////////////////////////
            
            // minimization g
            func g(α: Double)->Double{
                //var result = [Double]()
                //result.append( x[0] + α*S[0] )
                //result.append( x[1] + α*S[1] )
                var result : [Double] = [ x[0] + α*S[0], x[1] + α*S[1] ]
                
                return f(arg: result)
            }
            
            min_α = MinCoordinate(function: g(α:))
            print("         min_α = ", min_α)
            
            // x_next
            for i in x.indices {
                x_next[i] = x[i] + min_α * S[i]
            }
            
            // Exiting condition
            if v_norm(vector: v_Substraction(vector1: x_next, vector2: x)) < Eps2 && fabs(f(arg: x_next) - f(arg: x)) < Eps2 {
                if predTimeMet || k < 1
                    {
                        print(" !!!! pred time !!!!")
                        break
                    }
                else {
                    predTimeMet = true
                }
            }
            else {
                predTimeMet = false
            }
            
            x_pred = x
            x = x_next
            k+=1
            
            print()
        }
            
            print("  min  ->  \(x)")
            print("k = \(k)")
            print()
    }
}

class Newton: FletcherRivesMethod {
    
    func matrix_x_vector(a: [[Double]], x: [Double])->[Double] {
        var res : [Double] = Array (repeating: 0, count: x.count)
        
        for i in 0..<x.count {
            for j in 0..<x.count {
                res[i]+=a[i][j]*x[j]
            }
        }
        return res
    }
    
    func DoubleDerivativeMatrix(/*function: [Double]->[Double], grad: [Double]*/) -> [[Double]] {
        return [[10, -1],
                [2, -1]]
    }
    
    func inversedMatrix(a: [[Double]]) -> [[Double]] {
        let det = a[0][0]*a[1][1] - a[0][1]*a[1][0]
        var res : [[Double]] = [[0,0],[0,0]]
        res[0] = [a[1][1], -a[1][0] ]
        res[1] = [-a[0][1], a[0][0] ]
        
        for i in a.indices {
            for j in a[i].indices {
                res[i][j] /= det
            }
        }
        return res
    }
    
    /*<>><><>*/override func solve(x0: [Double]) {
            var x=x0, x_next = x0, x_pred = x0,
            k = 0, min_α: Double,
            predTimeMet = false,
            S: [Double],  B: Double;
            
            // Init S
            S = [ -(grad(arg: x)[0]), -(grad(arg: x)[1]) ]
        
        let antiGrad = S;

            
            while v_norm(vector : grad(arg: x)) > Eps1 && (k < iterationLimit) {
                print("norm =", v_norm(vector : grad(arg: x)))
                //recomputing S
                if k>0 {
                    /*S*/
                    
                    S = matrix_x_vector(a: inversedMatrix(a: DoubleDerivativeMatrix()), x: <#T##[Double]#>)
                    //for i in x.indices {
                    //    S[i] = -grad(arg: x)[i] + B * S[i]
                    //}
                }
                ////////////////////////////////////////////////////
                
                // minimization g
                func g(α: Double)->Double{
                    //var result = [Double]()
                    //result.append( x[0] + α*S[0] )
                    //result.append( x[1] + α*S[1] )
                    var result : [Double] = [ x[0] + α*S[0], x[1] + α*S[1] ]
                    
                    return f(arg: result)
                }
                
                //min_α = MinCoordinate(function: g(α:))
                min_α = 1.0;
                
                // x_next
                for i in x.indices {
                    x_next[i] = x[i] + min_α * S[i]
                }
                
                // Exiting condition
                if v_norm(vector: v_Substraction(vector1: x_next, vector2: x)) < Eps2 && fabs(f(arg: x_next) - f(arg: x)) < Eps2 {
                    if predTimeMet || k < 1
                    {
                        print(" !!!! pred time !!!!")
                        break
                    }
                    else {
                        predTimeMet = true
                    }
                }
                else {
                    predTimeMet = false
                }
                
                x_pred = x
                x = x_next
                k+=1
                
                print()
            }
            
            print("  min  ->  \(x)")
            print("k = \(k)")
            print()
    }
    
}

class NewtonRaphson: Newton {
    override func solve(x0: [Double]) {
        
    }
}

print("      || Gradient descent: ||")
let gradInstance = GradientDescent(initialApproximation: [0.1,-0.1])

print("      || Flethcer-Rives Method: ||")
let FR = FletcherRivesMethod(initialApproximation: [1.5,1.0])

