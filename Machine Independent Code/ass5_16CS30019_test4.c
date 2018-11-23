int main()
{
	//to check the loops
	int i,j=0,k=0;
	int sum=5;
	double a[10];
	int x=2,y=5;
	for(i=0;i<sum;i++)
	{
		a[i]=x+y;
		x++;
		y--;
	}
	while(sum>1)
	{
		a[i]=a[i-1]+1;
		sum=sum-1;
	}
	sum=0;
	do{
		x=x+y;
		sum++;
	}while(sum>0&&sum<5);
	int whiley=1;
	while(whiley)
	{
		whiley--;
	}
}
