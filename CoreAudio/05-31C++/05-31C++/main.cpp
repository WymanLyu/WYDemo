//
//  main.cpp
//  05-31C++
//
//  Created by wyman on 2017/5/31.
//  Copyright © 2017年 wyman. All rights reserved.
//

#include <iostream>

using namespace std;

class Box
{
    
    double hh;
    

    
public:
    double length; // 长度
    double breadth;// 宽度
    double height; // 高度
    
    // 函数声明
    double getVolume(void); // 获取体积
    
    // 打印私有
    void printPrivate(void);
    
    // 打印保护
    void printProtect(void);
    
    // print
    void print(int a)
    {
        cout << "int " << a << endl;
    }
    // print
    void print(double a)
    {
        cout << "double " << a << endl;
    }
    // print
    void print(char *a)
    {
        cout << "char * " << a << endl;
    }
    
    Box operator+(const Box&b)
    {
        Box box;
        box.print("bbb");
        return box;
    }
    
private:
    double pp;
    

    
protected:
    double prr;
    
 

};

void Box::printPrivate()
{
    cout << "hh :" << hh << "   pp :" << pp << endl;
}

void Box::printProtect()
{
    cout << "prr :" << prr << endl;
}


double Box::getVolume()
{
    hh = 20;
    return this->length;
}


// 图像
class Shape {
    
protected:
    int area;
    
protected:
    int width, height;
    
public:
    char type = 's';
    Shape(int w, int h)
    {
//        cout << "Shape的构造函数" << endl;
        this->width = w;
        this->height = h;
    }
    
    void printArea()
    {
        cout << "父类 面积：" << this->width*this->height << endl;
    }
    
    void f (int a) {
        cout << "Shape f " << a <<endl;
    }
};

// Rectangle
class Rectangle : public Shape {
    
    
public:
    Rectangle(int w, int h) : Shape(w, h)
    {
//        cout << "Rectangle的构造函数" << endl;
    }
    
    void printArea()
    {
        cout << "Rectangle 面积：" << this->width*this->height << endl;
    }
    
    void f (int a) {
        cout << "Rectangle f " << a <<endl;
    }
};


int main(int argc, const char * argv[]) {
    
    
    Shape father = Shape(2, 5);
//    father.printArea();
    father.f(88);
    Rectangle son = Rectangle(3,6);
//    son.printArea();
    son.f(88);
    
    Shape *duotai = &son;
//    duotai->printArea();
    duotai->f(88);
    
    

    
//    int a = 20;
//    char name[] = "name";
//    Shape *shap = new Shape(10, 20);
//    shap->printArea();
//    cout << "---" << endl;
//    Shape shap_stack = Shape(22,33);
//    
//    
//    Shape *shap_copy = new Shape(*shap);
//    shap_copy->printArea();
//    
//    // 闭包
//    // [某变量名] 某变量名值传递
//    // [=] 所有变量值传递
//    // [&某变量名] 某变量名引用传递
//    // [&] 所有变量引用传递
//    // [=, &某变量名] 某变量名引用传递，其余值传递
//    
//    auto block  = [=, &a](){
//        a = 110;
//        cout << "这是什么？？" << shap_stack.type << endl;
//    };
//    
//    
//    block();
//    
//    cout << a << endl;
    
    
    return 0;
}
























