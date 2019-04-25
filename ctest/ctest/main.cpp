#include <iostream>
#include <vector>
#include "math.h"


#define EPS 1e-12
using namespace std;

vector<double> GaussMethod(vector<vector<double>> a, vector<double> b ) {

    vector < double > x = {1,1};
    int n = b.size();                     //Размерность

//Прямой ход метода Гауса
    for ( int k = 0; k < n - 1; k++ )
        for (int i = k + 1; i < n; i++) {
   
            double div;
            if (abs(a[k][k]) > EPS)
                div = (double) a[i][k] / a[k][k];
            else {
                cout << "System linear depended";
            }
            
            b[i] -= div * b[k];
            for (int j = k; j < n; j++)
            a[i][j] -= div * a[k][j];
            }
            //Проверка на вырожденность
            for( int i = 0; i < n; i++)
            if (a[i][i] == 0) {
                cout << "|A|=0 ";
                //return 1;
            }
            
            //Обратный ход метода Гауса
            x[n - 1] = (double) b[n - 1] / a[n - 1][n - 1];   // Вычисляем x[n]
            for (int i = n - 2; i >= 0; i--) {
                int sum = b[i];                    //Сумма переноса вправо для очередной строки
                for (int j = i + 1; j < n; j++)
                    sum -= a[i][j] * x[j];
                
                if ( abs ( a[i][i] ) > EPS )
                    x[i] = (double)sum / a[i][i];
                else {
                    cout << "Method not work ";
                    //return 1;
                }
                
                
                
            }
            
            //for ( int i = 0; i < n; i++)
            //cout << "x[" << i << "]= " << x[i] << '\n' ;
    
    return x;
}

vector<double> LU_decomposition(vector<vector<double>> a, vector <double> b, vector <double> x /*init*/){
    
    const int n = a.size();
    
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
                //return 1;
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
            //return 1;
        }
    }
    
    //for (auto &iter: x) {
    //    cout << iter<< endl;
    //}
  
    return x;
}

vector<vector<double>> scalar_x_matrix(double scalar, vector<vector<double>> a){
    for (int i=0; i<a.size(); i++)
        for (int j=0; j<a.size(); j++)
            a[i][j]*=scalar;
        
    return a;
}

vector<double> scalar_x_vector(double scalar, vector<double> v){
    for (int i=0; i<v.size(); i++)
            v[i]*=scalar;
    return v;
}

vector<vector<double>> matrixAddition(vector<vector<double>> a, vector<vector<double>> b){
    for (int i=0; i<a.size(); i++)
        for (int j=0; j<a.size(); j++)
            a[i][j]+=b[i][j];
    
    return a;
}

vector<double> vectorAddition(vector<double> v1, vector <double> v2){
    for (int i=0; i<v1.size(); i++) {
        v1[i]+=v2[i];
    }
    return v1;
}

double funcP( double x, double y, double r ) {
    return r/2*pow(x+y-1, 2);
}

void outputVector(vector<double> v){
    for (auto &iter: v) {
        cout << iter<< "  ";
    }
    cout << endl;
}


int main()
{
  
    vector < vector < double > > a = {{10,-1}, {-1,2}};
    vector < double > b = {0,0}, x= {1,1};  //Вектора x,b
    
    vector <vector<double>> phi = {{1,1}, {1,1}};
    vector<double> phi_right = {1,1};
    
    int n = 2;                       //Размерность
    int k = 0;
    double r = 1.0;
    const double eps = 1e-8;
    
    do {
        x = LU_decomposition(matrixAddition(a, scalar_x_matrix(r, phi)), vectorAddition(b, scalar_x_vector(r, phi_right)), x);
        //x = GaussMethod(matrixAddition(a, scalar_x_matrix(r, phi)), vectorAddition(b, scalar_x_vector(r, phi_right)));
        outputVector(x);
        r*=10;
        k++;
    } while (funcP(x[0], x[1], r) > eps);
    
    
    cout << " k = "<<k<<endl;
    
    /*vector<double> v = LU_decomposition({{11,0},{0,3}}, {1,1}, {1,1});
    outputVector(v);
    cout << endl;*/
    
    /*auto m = matrixAddition( {{10,-1}, {-1,2}}, scalar_x_matrix(1, {{1,1}, {1,1}}));
    for (int i=0; i<a.size(); i++){
        cout << endl;
        for (int j=0; j<a.size(); j++)
            cout << m[i][j] << "  ";
    }*/
}
