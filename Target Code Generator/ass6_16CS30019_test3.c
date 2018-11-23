int singledigit(int x)       // Recursive function that will return the sum of every single digit
{
    if((x/10)==0)
    {
        return x;
    }
    else
    {
        return (singledigit(x%10)+singledigit(x/10));     // It will calculate the sum of the digits of the number.
    }
}

int main()
{
    int n;
    prints("This Programs calculate whether a number is a magic number or not.A Magic number is a number whose sum of digits eventually leads to 1.\n");
    prints("ENTER NUMBER\n");    // To input a number
    int err=1;
    n=readi(&err);
    while((n/10)!=0)
    {
        n=singledigit(n);     // Calculate the sum of the digits until you get a single digit i.e from 0 to 9 and then check if it is 1
    }
    if(n==1)       // After you get a single digit then check if the sum of the digits is eventually 1 then it is magical else not
    {
        prints("Number is magic\n");
    }
    else
    {
        prints("numebr is not magic\n");
    }
    return 0;
}
