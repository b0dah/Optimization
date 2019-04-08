//
//  main.swift
//  OM_Fibonacci_Method
//
//  Created by Иван Романов on 19/03/2019.
//  Copyright © 2019 Иван Романов. All rights reserved.
//

import Foundation

var FibArray : [Double] = [0,1,1] // восстановить нумерацию, первое число в [1]

func f(x: Double) -> Double {
    //return (x-1)*(x-1)
    //return x*x
    return 2*x*x + 2*x + 7/2
}

func generateFibGreaterThanX(X: Double){
    var f_pred = 1.0, f = 1.0, temp = 1.0
    
    while f <= X {
        temp = f
        f+=f_pred
        FibArray.append(f)
        f_pred = temp
    }
}


///////////////////////// Fibonacci ////////////////////////////////////////////

///*I*/
let Eps = 1e-8, Δ = 1e-12, Accuracy = 1e-12
var a = -3.0, b = 7.0


var k = 1

generateFibGreaterThanX(X: round( Double(b-a)/Eps ))
let n = FibArray.count-1

var λ: Double = a + FibArray[n-2]/FibArray[n]*(b-a),
    μ: Double = a + FibArray[n-1]/FibArray[n]*(b-a)

///*II*/
while k < (n-2) {
    
    k+=1
    
    if f(x : λ) > f(x : μ) {
        a = λ
        
        λ = μ
        μ = a + Double(FibArray[n-k-1]/FibArray[n-k])*(b-a)
    }
    else {
        b = μ
        
        μ = λ
        λ = a + Double(FibArray[n-k-2]/FibArray[n-k])*(b-a)
    }
            //print("a = \(a), b = \(b)")
}

/*5*/
    μ = λ + Δ
    if f(x : λ) < f(x : μ) {
        b = μ
    }
    else if fabs( f(x : λ) - f(x : μ) ) < Accuracy {
        a = λ
    }

        //print(FibArray)
//print("k = \(k)")
print("Fibonacci answer is    \( (a + b)/2 )          \(k) iterations done")

/////////////////////// GOLDEN RATIO ///////////////////////////

a = -3.0
b = 7.0

let φ = (3 - sqrt(5)) / 2
    λ = a + φ*(b-a)
    μ = a + b - λ

    k = 0

repeat {
     k+=1
    
    if f(x: λ) < f(x: μ){
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
while fabs(a-b) >= 2*Eps

print("GOLDEN RATIO answer is \( (a + b)/2 )        \(k) iterations done")
print("\n")

