//
//  main.swift
//  OT_FineMethod
//
//  Created by Иван Романов on 26/04/2019.
//  Copyright © 2019 Иван Романов. All rights reserved.
//

import Foundation

class FlethcerRives {
    let Eps1 = 1e-8, Eps2 = 1e-8, iterationLimit: Int = 10
    
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
    
    /*!*/func MinCoordinate(function: (Double) -> Double) -> Double {
        
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
    
    func solve(x0: [Double], f: @escaping ([Double]) -> Double) ->[Double] {
        
        
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
                
                var result : [Double] = [ x[0] + α*S[0], x[1] + α*S[1] ]
                
                return f(result)
            }
            
            min_α = MinCoordinate(function: g(α:))
            print("         min_α = ", min_α)
            
            // x_next
            for i in x.indices {
                x_next[i] = x[i] + min_α * S[i]
            }
            
            // Exiting condition
            if v_norm(vector: v_Substraction(vector1: x_next, vector2: x)) < Eps2 && fabs(f(x_next) - f(x)) < Eps2 {
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
    
    init(initialApproximation: [Double], sourceFunction: @escaping ([Double])->Double) {
       // solve(x0: initialApproximation, f: sourceFunction )
    }
    
}



func funcP( x : Double, y: Double, r: Double )->Double {
    return r/2*pow(x+y-1, 2);
}

func FineMethod(/* -> Funcs */   sourceFunction: @escaping (Double, Double)->Double){//, condFunction: @escaping  (Double, Double)->Double) {
        
        var r = 1.0
        var x=[1.0, 1.0], k=0
    
        let Eps = 1e-8
        
        while (funcP(x: x[0], y: x[1], r: r)) > Eps {
            
            func compositeFun(x: [Double]) -> Double {
      
                return sourceFunction(x[0], x[1]) + funcP(x: x[0], y: x[0], r: r)
            }
            
            let FR = FlethcerRives(initialApproximation: x, sourceFunction: compositeFun)
            x=FR.solve(x0: x, f: compositeFun)
            print(x)
            
            r*=5
            k+=1
            
        }
}

func FineFunction(x:Double, y:Double)->Double{
    return 5*x*x + y*y - x*y+x
}

print(FineMethod(sourceFunction: FineFunction))


    


