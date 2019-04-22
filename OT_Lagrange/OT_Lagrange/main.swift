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

