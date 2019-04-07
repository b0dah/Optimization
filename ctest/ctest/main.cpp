//
//  main.cpp
//  ctest
//
//  Created by Иван Романов on 07/04/2019.
//  Copyright © 2019 Иван Романов. All rights reserved.
//

#include <iostream>

double f(double x) {
    return x;
}

const double h = 1e-1;
double x = 1.0;

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << (f(x+h) - f(x-h))/(double)(2.0*h) << std::endl;
    std::cout << 2.0*h;
    return 0;
}
