//
//  main.swift
//  OT_Lagrange
//
//  Created by Иван Романов on 21/04/2019.
//  Copyright © 2019 Иван Романов. All rights reserved.
//

import Foundation


class Substitution {
    
    let Eps = 1e-8
    
    func dichotomy(function: (Double)->Double) -> Double  {
        let eps = Eps
        let delta = eps
        
        var a = -10.0, b = 10.0, c: Double = 0.0;
        
        while fabs(b - a) > eps {
            c = (a + b) / Double(2);
            
            if function( c-delta) < function( c+delta) {
                b = c;
            }
            else {
                a = c;
            }
        }
        //print(" min = " , (a + b) / Double(2) )
        return (a + b) / 2
    }
    
    func Xtakenout( function: ( Double, Double)->Double, y: Double ) -> Double { // returns X
        let x_coefficient : Double = function(1.0,0.0) - function(0.0,0.0)
        return Double(-1 * function(0, y)) / Double(x_coefficient)
    }
    
    
    init(/* -> Funcs */   sourceFunction: @escaping (Double, Double)->Double, condFunction: @escaping  (Double, Double)->Double) {
        
        func OneDimensionalFunction(arg: Double)-> Double { // U
            return sourceFunction( Xtakenout(function: condFunction, y: arg), arg)
        }
        
        print(Xtakenout(function: condFunction, y: 1.0))
        print("-> U=", OneDimensionalFunction(arg: 1.0))
        
        print("Conditional Extremum **->")
        print("  ", Xtakenout(function: condFunction, y: dichotomy(function: OneDimensionalFunction(arg:))))
        print("  ", dichotomy(function: OneDimensionalFunction))
    }
    
    
}

class GradientDescent  {
    let Eps1 = 1e-8, Eps2 = 1e-8, iterationLimit: Int = 1000
    
    //var x: [Double]
    
    /*+*/func f(arg: [Double]) -> Double {
        let x = arg[0], y = arg[1]
        //return x*x + y*y
        //return 5*x*x + y*y - x*y + x
        return x*x + 5*y*y - x*y + x
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
            
            min_α = MinCoordinate(function: g(α:) )
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
    
    
    init(initialApproximation: [Double], sourceFunction: @escaping (Double, Double)->Double) {
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
    
    func solve(x0: [Double]) ->[Double] {
        
        
        
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
        
        return x;
    }
    
    init(func: (Double, Double)->Double) {
        solve(x0: <#T##[Double]#>)
    }

}


class FineMethod{
    
    let Eps = 1e-8
    
    func funcP( x : Double, y: Double, r: Double )->Double {
        return r/2*pow(x+y-1, 2);
    }
    
    init(/* -> Funcs */   sourceFunction: @escaping (Double, Double)->Double, condFunction: @escaping  (Double, Double)->Double) {
        
        var r = 1.0
        var x=1.0, y=1.0, k=0

        while (funcP(x: x, y: y, r: r)) > Eps {
            
            func compositeFun(x: Double, y: Double) -> Double {
                return sourceFunction(x, y) + funcP(x: x, y: y, r: r)
            }
            
            
            
            
            r*=5
            k+=1
            
        }
    }
    
}
/////// SOLving //////////////////////////////////////////////

// a) ****
func fA(x: Double, y : Double) -> Double {
    return 5*x*x + y*y - x*y + x
}

func linearConditionA(x: Double, y: Double) -> Double {
    return x+y-1
}
// b) ***
func fB(x: Double, y : Double) -> Double {
    return x*x + 8*y*y + x*y + x
}

func linearConditionB(x: Double, y: Double) -> Double {
    return 3*x+y-2
}


let LagrangeFirstInstance = Substitution(sourceFunction: fA, condFunction: linearConditionA)

print(" -----B: --------")
let LagrangeSecondInstance = Substitution(sourceFunction: fB, condFunction: linearConditionB)
//print(LagrangeInstance.One)

