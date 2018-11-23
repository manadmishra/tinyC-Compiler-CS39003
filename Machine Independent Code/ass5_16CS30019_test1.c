int func(int a,int b);
int div(int a,int b);
int sum(int a,int b);
int mod(int a, int b);


int main()
{
	//testing the function declarations 
	int x=4,y=12;
	int sm=sum(x,y);
	int md=mod(x,y);
	int md_2=func(x,y);
	if(md==md_2)
	{
		y=3;
	}
	else{
		y=4;
	}
	func(x,y);
}


int mod(int a,int b)
{
	int ans=a%b;
	return ans;
}

int sum(int a,int b)
{
	int ans=a+b;
	return ans;
}

int div(int a,int b)
{
	int ans;
	if(b!=0)
		ans=a/b;
	else
		ans=-2;
	return ans;
}
int func(int a,int b)
{
	int ans;
	if(a<b)
		ans=a-div(a,b);
	else
		ans=b-div(a,b);
	return ans;
}