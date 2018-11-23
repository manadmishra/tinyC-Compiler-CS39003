int printi(int num);
int prints(char * c);
int readi(int *eP);

int func(int *a)
{
    int b;
    b = *a;
    b = b + 2;
    return b;
}
int main()
{
    int a,b;
    int *e;
    
    prints("output text\n");
    
    b = 3;
    e = &b;

    prints("Passing pointers to function func\n");
    prints("Value passed to function: ");
    printi(b);
    prints("\n");
    
    prints("Value returned from function s is: ");
    printi(a);
    prints("\n");
    
    prints("Read an integer");
    prints("\n");
    b = readi(e);
    prints("The integer that was read is:");
    printi(b);
    prints("\n");
    

    return 0;
}
