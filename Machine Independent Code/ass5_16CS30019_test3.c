int main()
{
	//testing common expressions 
	int a,b=3;
	a=b+2;
	b = a%b;
	double db1,db2=8.9;
	db1= a*db2;
	int *p1=&a;
	if(*p1==a)
	{
		b=a*2;
	}
	else
	{
		b=a*3;
	}
	int arr[11],brr[21][21];
	while(a<b)
	{
		arr[a]=a;
		brr[a][b]=a+b;
		a++;
	}
	arr[7]++;
	int leftsh = b<<2;
	int **p2=&b;
	char ch1,ch2;
	ch1='a';
	double sum = ((a+b)*ch1)+db2;
	db1=2.3;
	db2=db2/db1;
	ch2 = 'b';
	ch1++;
	if(ch1==ch2)
	{
		--sum;
	}
}

