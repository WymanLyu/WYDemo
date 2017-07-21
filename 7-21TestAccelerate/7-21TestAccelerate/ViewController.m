//
//  ViewController.m
//  7-21TestAccelerate
//
//  Created by wyman on 2017/7/21.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"
#import <Accelerate/Accelerate.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
     matrixMul();
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 矩阵求逆矩
void matrixInversion()
{
    // 暂无 参考https://stackoverflow.com/questions/11282746/how-to-perform-matrix-inverse-operation-using-the-accelerate-framework
    double a[9] = {1,1,7,1,2,1,1,1,3};
    double b[9];
    matrix_invert(3, a, b);
    printf("|￣%.1f, %.1f, %.1f￣|^-1   |￣%.1f, %.1f, %.1f￣| \n", a[0], a[1],a[2], b[0], b[1], b[2]);
    printf("|  %.1f, %.1f, %.1f |    = |  %.1f, %.1f, %.1f | \n", a[3], a[4], a[5], b[3], b[4], b[5]);
    printf("|＿%.1f, %.1f, %.1f＿|      |＿%.1f, %.1f, %.1f＿| \n", a[6], a[7], a[8], b[6], b[7], b[8]);

}

int matrix_invert(int N, double *ori_matrix, double *matrix) {

    // 拷贝
    for (int i=0; i < N*N; i++) {
        matrix[i] = ori_matrix[i];
    }

    int error=0;
    int *pivot = malloc(N*sizeof(int)); // LAPACK requires MIN(M,N), here M==N, so N will do fine.
    double *workspace = malloc(N*sizeof(double));

    /*  LU factorisation */
    dgetrf_(&N, &N, matrix, &N, pivot, &error);

    if (error != 0) {
        NSLog(@"Error 1");
        free(pivot);
        free(workspace);
        return error;
    }

    /*  matrix inversion */
    dgetri_(&N, matrix, &N, pivot, workspace, &N, &error);

    if (error != 0) {
        NSLog(@"Error 2");
        free(pivot);
        free(workspace);
        return error;
    }

    free(pivot);
    free(workspace);
    return error;
}

#pragma mark - 矩阵转置
void matriTranspose()
{
    float a[6] = {3, 2, 4, 5, 6, 7}; // 3x2矩阵
    float b[6];
    vDSP_mtrans(a, 1, b, 1, 2, 3); // 后两个参数 结果矩阵的行数和列数
    printf("|￣%.1f, %.1f￣|T   |￣%.1f, %.1f, %.1f￣| \n", a[0], a[1],b[0], b[1], b[2]);
    printf("|  %.1f, %.1f |  = |＿%.1f, %.1f, %.1f＿| \n", a[2], a[3], b[3], b[4], b[5]);
    printf("|＿%.1f, %.1f＿|                          \n", a[4], a[5]);

}

#pragma mark - 矩阵乘法
void matrixMul()
{
    float a[6] = {3, 2, 4, 5, 6, 7}; // 3x2矩阵
    float b[6] = {10, 20, 30, 30, 40, 50}; // 2x3矩阵
    float c[9];
    vDSP_mmul(a, 1, b, 1, c, 1, 3, 3, 2); // 后三个参数 结果矩阵的行数，列数，计算累加的数（就是a矩阵的列数）
    printf("|￣%.1f, %.1f￣|   |￣%.1f, %.1f, %.1f￣|     |￣%.1f, %.1f, %.1f￣|\n", a[0], a[1],b[0], b[1], b[2], c[0], c[1], c[2]);
    printf("|  %.1f, %.1f | * |＿%.1f, %.1f, %.1f＿|  =  |  %.1f, %.1f, %.1f |\n", a[2], a[3], b[3], b[4], b[5], c[3], c[4], c[5]);
    printf("|＿%.1f, %.1f＿|                             |＿%.1f, %.1f, %.1f＿|\n", a[4], a[5], c[6], c[7], c[8]);
}

#pragma mark - 点乘
void dotMul()
{
    float a[2] = {1, 2};
    float b[2] = {2, 4};
    float c = 0;
    vDSP_dotpr(a, 1, b, 1, &c, 2);
    printf("(%.1f,%.1f)·(%.1f,%.1f) = %.1f", a[0], a[1], b[0], b[1], c);
}

#pragma mark - 除法
void divide()
{
    // v/v除法 实数向量和实数向量相除 - Vector & Vector
    float a[3] = {1,2,3};
    float b[3] = {1,2,4};
    float c[3];
    vDSP_vdiv(b, 1, a, 1, c, 1, 3);
    //    vDSP_vmulD(a, 1, b, 1, c, 1, 3); 【函数名带有D代表是double类型】
    printf("(%.1f,%.1f,%.1f) / (%.1f,%.1f,%.1f) = (%.1f,%.1f,%.1f)\n", a[0], a[1], a[2], b[0], b[1], b[2], c[0], c[1], c[2]);

    // v/v除法 复数向量和实数向量相除 - Vector & Vector
    float g[2] = {1, 3}; // 实部
    float h[2] = {2, 4}; // 虚部
    float number[2] = {2.0, 3.0};
    float j[2];
    float k[2];
    DSPSplitComplex m = {g, h};
    DSPSplitComplex n = {j, k};
    vDSP_zrvdiv(&m, 1, number, 1, &n, 1, 2);
    printf("((%.1f+%.1fi), (%.1f+%.1fi)) / (%.1f, %.1f) = ((%.1f+%.1fi), (%.1f+%.1fi))\n", g[0], h[0], g[1], h[1],number[0], number[1], j[0], k[0], j[1],k[1]);

    // v/s除法 向量和常数相除 - Vector & Scalars
    double d[3] = {1,2,3};
    double e = 2;
    double f[3];
    vDSP_vsdivD(d, 1, &e, f, 1, 3);
    printf("(%.1f,%.1f,%.1f) / %.1f = (%.1f,%.1f,%.1f)\n", d[0], d[1],d[2], e, f[0], f[1], f[2]);

}

#pragma mark - 加法
void add()
{
    // v+v加法 实数向量和实数向量相加 - Vector & Vector
    float a[3] = {1,2,3};
    float b[3] = {1,2,4};
    float c[3];
    vDSP_vadd(a, 1, b, 1, c, 1, 3);
    //    vDSP_vmulD(a, 1, b, 1, c, 1, 3); 【函数名带有D代表是double类型】
    printf("(%.1f,%.1f,%.1f) + (%.1f,%.1f,%.1f) = (%.1f,%.1f,%.1f)\n", a[0], a[1], a[2], b[0], b[1], b[2], c[0], c[1], c[2]);

    // v+v加法 复数向量和实数向量相加 - Vector & Vector
    float g[2] = {1, 3}; // 实部
    float h[2] = {2, 4}; // 虚部
    float number[2] = {2.0, 3.0};
    float j[2];
    float k[2];
    DSPSplitComplex m = {g, h};
    DSPSplitComplex n = {j, k};
    vDSP_zrvadd(&m, 1, number, 1, &n, 1, 2);
    printf("((%.1f+%.1fi), (%.1f+%.1fi))+(%.1f, %.1f) = ((%.1f+%.1fi), (%.1f+%.1fi))\n", g[0], h[0], g[1], h[1],number[0], number[1], j[0], k[0], j[1],k[1]);

    // v+s加法 向量和常数相加 - Vector & Scalars
    double d[3] = {1,2,3};
    double e = 2;
    double f[3];
    vDSP_vsaddD(d, 1, &e, f, 1, 3);
    printf("(%.1f,%.1f,%.1f) + %.1f = (%.1f,%.1f,%.1f)\n", d[0], d[1],d[2], e, f[0], f[1], f[2]);

}


#pragma mark - 减法
void sub()
{
    // v-v减法 实数向量和实数向量相减 - Vector & Vector
    float a[3] = {1,2,3};
    float b[3] = {1,2,4};
    float c[3];
    vDSP_vsub(b, 1, a, 1, c, 1, 3);
    //    vDSP_vmulD(a, 1, b, 1, c, 1, 3); 【函数名带有D代表是double类型】
    printf("(%.1f,%.1f,%.1f) - (%.1f,%.1f,%.1f) = (%.1f,%.1f,%.1f)\n", a[0], a[1], a[2], b[0], b[1], b[2], c[0], c[1], c[2]);

    // v-v减法 复数向量和实数向量相减 - Vector & Vector
    float g[2] = {1, 3}; // 实部
    float h[2] = {2, 4}; // 虚部
    float number[2] = {2.0, 3.0};
    float j[2];
    float k[2];
    DSPSplitComplex m = {g, h};
    DSPSplitComplex n = {j, k};
    vDSP_zrvsub(&m, 1, number, 1, &n, 1, 2);
    printf("((%.1f+%.1fi), (%.1f+%.1fi))-(%.1f, %.1f) = ((%.1f+%.1fi), (%.1f+%.1fi))\n", g[0], h[0], g[1], h[1],number[0], number[1], j[0], k[0], j[1],k[1]);

    // v-s减法 向量和常数相减 - Vector & Scalars
    // 没有api
}

#pragma mark - 乘法
void mul()
{
    // v*v乘法 实数向量和实数向量相加 - Vector & Vector
    float a[3] = {1,2,3};
    float b[3] = {1,2,4};
    float c[3];
    vDSP_vmul(a, 1, b, 1, c, 1, 3);
//    vDSP_vmulD(a, 1, b, 1, c, 1, 3); 【函数名带有D代表是double类型】
    printf("(%.1f,%.1f,%.1f) * (%.1f,%.1f,%.1f) = (%.1f,%.1f,%.1f)\n", a[0], a[1], a[2], b[0], b[1], b[2], c[0], c[1], c[2]);

    // v*v乘法 复数向量和实数向量相乘 - Vector & Vector
    float g[2] = {1, 3}; // 实部
    float h[2] = {2, 4}; // 虚部
    float number[2] = {2.0, 3.0};
    float j[2];
    float k[2];
    DSPSplitComplex m = {g, h};
    DSPSplitComplex n = {j, k};
    vDSP_zrvmul(&m, 1, number, 1, &n, 1, 2);
    printf("((%.1f+%.1fi), (%.1f+%.1fi))*(%.1f, %.1f) = ((%.1f+%.1fi), (%.1f+%.1fi))\n", g[0], h[0], g[1], h[1],number[0], number[1], j[0], k[0], j[1],k[1]);

    // v*s乘法 向量和常数相乘 - Vector & Scalars
    double d[3] = {1,2,3};
    double e = 2;
    double f[3];
    vDSP_vsmulD(d, 1, &e, f, 1, 3);
    printf("(%.1f,%.1f,%.1f) * %.1f = (%.1f,%.1f,%.1f)\n", d[0], d[1],d[2], e, f[0], f[1], f[2]);

}



@end
