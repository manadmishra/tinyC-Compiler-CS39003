/*
Test C program to check the working of the lexer.
Check Multi line comment
*/
#include<stdio.h>

#define name "Manad\t\n"

inline void function(char[] text);

typedef struct item {
    struct item* next;
    int key =0;
    int val=0;
}


main(){

   int arr[] = {2, 3, 4, 10, 40};
   int n = sizeof(arr)/ sizeof(arr[0]);
   int x = 10;
    

    //testing identifiers and constants:
    _Bool   a,b;
    _Complex    c;
    extern unsigned float=0.0;
    static short m=0;
    volatile signed long delta = 9;
    _Imaginary  d;
    int num = 69;
    double e=9.41;
    char text[10];
    str ="Compiler Lab Assignment\n\t";
    float temp = -40.45 ;
    char ch='t';
    int max=45, min=23;
 
    //testing all the keywords here
    auto, break, case, char, const, continue, default, 
    do, double, else, enum, extern, float,  short, signed, sizeof, static, struct, switch,for, 
    goto, if, inline, int, long, register,
    restrict, return, typedef, union,
    unsigned, void, volatile, while, _Bool, _Complex, _Imaginary

    item* base=NULL
    
    function(str);
    temp=sizeof(char*)

    int i=2;

    for(i=0;i<50;i++) {
        switch(i) {
            case(1) : continue;
            case(2) : break;
            default : return -1;
        }
    }



    do{ 
        if (max==min){
            base=base->next;
            base->data=i/10;
            i=i%2;
            base->data = {[(i>>5)<<8]+9}-100;
            if(text!="HI !") text="HI\a\b\v";
            i=8^5;
            i--;
            i=i|base->data;
        }
        else if(max>=min) {

            i++;
            i=i/2;
            i=i+52;
            if (i&&0||!i) i=~i;
           
        }

        else if(max>=min) {
            base->data = (i*=11 > 5||i/=10 < 5) ? i:0;
            i%=20;
            i+=5;
            i-=7;
            i<<=5;
            i>>=2;
            i&=21;
            i^=12;
        }

        else {
            auto int j=0,k=0;
            j|=54;
            #define R 77
            k*=R;
            break;
        }
    }

    while(num++<100);
    
    return 0;
}


inline void function(char[] text){
    char[20] sum=text+name;
    printf("The output of this function is : %s \n",sum);
    enum beatles{"paul","john","george","ringo"};
}

