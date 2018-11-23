int main()
{
	//to test the if else conditions
	int a=2,b=3;
	char c='i';
	char d='k';
	double sum=0.1;
	if(b>a)
	{
		if(c>d)
		{
			sum=sum+c;
			sum=sum+b;
		}
		else
		{
			sum=sum+d;
			sum=sum+b;
		}
	}
	else
	{
		if(c>d)
		{
			sum=sum+c;
			sum=sum+a;
		}
		else
		{
			sum=sum+d;
			sum=sum+a;
		}
	}
}
