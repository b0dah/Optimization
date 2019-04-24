//
//  main.cpp
//  ctest
//
//  Created by Иван Романов on 07/04/2019.
//  Copyright © 2019 Иван Романов. All rights reserved.
//

/*#include <iostream>

double f(double x) {
    return x;
}

const double h = 1e-1;
double x = 1.0;

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << (f(x+h) - f(x-h))/(double)(2.0*h) << std::endl; // divided by INT
    std::cout << 2.0*h;
    return 0;
} */

/*#include <iostream>
#include <string>
#include "math.h"
#include <vector>

using namespace std;

const int N = 2;

vector<vector<double>> matrix = {{-1, 1/3},
                                 {1/2, -1}};
vector<double> init_approx = {-1,-1};
vector<double> right_col = {1,1};

vector<double> iteration(vector<vector<double>> a, vector<double> x, vector<double> b)
{
    int i,j;
    const double eps = 1e-4;
    
    double norma; //чебышевская норма вектора
    vector<double> xn={1,1};//вектор для текущей итерации, начальное значение
    //должно быть равно начальному приближению
    
    int k = 0;
    
    do{
        norma=0.0;
        for(i=0;i < N;i++)
        {
            xn[i]=-b[i];
            
            for(j=0;j < N;j++)
            {
                if(i!=j)
                    xn[i]+=a[i][j]*x[j];
            }
            
            xn[i]/=-a[i][i];
        }
        
        for(i=0;i < N;i++)
        {
            if(fabs(x[i]-xn[i]) > norma)
                norma=fabs(x[i]-xn[i]); //Вычисление нормы вектора
            x[i]=xn[i];
        }
        k++;
    }
    while(norma > eps); //проверка на необходимую точность вычислений
    
    cout << "k=" << k<< endl;
    return x;
}

int main(){
    

    vector<double> a = iteration(matrix, init_approx, right_col);
    
    for (auto &iter: a ){
        cout << iter<< endl;
        
    }
    return 0;
}*/

#include <iostream>
#include <vector>
#include "math.h"

#define FILE_INPUT_PATCH "input.txt"
#define FILE_OUTPUT_PATCH "output.txt"
#define EPS 1e-12
using namespace std;


int main()
{
  
    vector < vector < double > > a = {{1,-1}, {-2,1}};
    vector < double > b = {1,1}, x= {1,1};  //Вектора x,b
    int n = 2;                       //Размерность
    vector < vector < double > > L; //  Нижнетреугольная матрица с единич диагональю
    vector < vector < double > > U; //Верхнетреугольная матрица
    

    //Инициализация
    L.resize(n);
    U.resize(n);
    for (int i = 0; i < n; i++) {
        L[i].resize(n);
        U[i].resize(n);
        L[i][i] = 1; //В L единичная диагональ
    }
    
    //Вычисление матриц L и U
    for (int i = 0; i < n; i++) {
        //Вычисляем строку U[i][...]
        for (int j = i; j < n; j++) { //Выбираем элемент строки U[i][...]
            U[i][j] = a[i][j];          //Вычисляем его (2.9)
            for (int k = 0; k < i; k++)
                U[i][j] -= L[i][k] * U[k][j];
        }
        //Вычисляем столбец L[...][i]
        //Замена: i столбцов и j строк
        for (int j = i + 1; j < n; j++) { //Выбираем элемент столбца L[...][i]
            L[j][i] = a[j][i];              //Вычисляем его (2.10)
            for (int k = 0; k < i; k++)
                L[j][i] -= L[j][k] * U[k][i];
            if ( abs(U[i][i]) > EPS )
                L[j][i] /= U[i][i];
            else {
                cout << "Error";
                return 1;
            }
        }
        
    }
    
    // Ly = b
    vector < double > y;
    y.resize(n);
    //Найдем y
    for (int i = 0; i < n; i++) { // Выбираем y
        y[i] = b[i];
        for (int k = 0; k < i; k++)
            y[i] -= L[i][k] * y[k];
    }
    
    //Ux = y
    for (int i = n - 1; i >= 0; i--) {
        x[i] = y[i];
        for (int k = i + 1; k < n; k++)
            x[i] -= U[i][k] * x[k];
        if ( abs(U[i][i]) > EPS )
            x[i] /= U[i][i];
        else {
            cout << "error" << '\n';
            return 1;
        }
    }
    
    for (auto &iter: x) {
        cout << iter<< endl;
    }
    
    
    
}
