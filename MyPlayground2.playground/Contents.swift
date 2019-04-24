import Cocoa

var str = "Hello, playground"

func Xtakenout( function: ( Double, Double)->Double, y: Double ) -> Double { // returns X
    let x_coefficient : Double = function(1.0,0.0) - function(0.0,0.0)
    return Double(-1 * function(0, y)) / Double(x_coefficient)
}


func linearConditionA(x: Double, y: Double) -> Double {
    return x+y-1
}

/*
func system(x: [Double], r: Double, phi: (Double, Double)->Double )->[Double] {
    return [ 10*x[0] + r*phi(x[0], x[1]),
             2*x[1] + r*phi(x[0],x[1]) ]
}*/

func system(x: [Double] )->[Double] {
    return [ 1/3*x[1] + 1.0,
             1/2*x[0] + 1.0 ]

}

func maxDifference(vector1: [Double], vector2: [Double]) -> Double {
    var diff : Double = fabs (vector1[0] - vector2[0])
    
    for i in vector1.indices{
        if fabs (vector1[i] - vector2[i]) > diff {
            diff = fabs (vector1[i] - vector2[i])
        }
    }
    return diff
}



func simpleIterations(Eps: Double) -> [Double]{
    var x = [0.0, 0.0],
        x_next = [1.0, 1.0],
    k = 0
    
    while maxDifference(vector1: x, vector2: x_next)>Eps {
        x = x_next
        x_next = system(x: x)
        k+=1
        
        print(x_next)
        //if k>10 {break}
    }
    print(k)
    return x_next
}

print(simpleIterations(Eps: 1e-3))

