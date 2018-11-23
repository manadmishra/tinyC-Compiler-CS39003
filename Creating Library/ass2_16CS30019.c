#include "myl.h"

#define BUFF 20 // filename  printInt.c++

int readInt(int *n)		//similar to readFlt
{
	int i = 0;
	int bytes = BUFF;
	char buff[BUFF];
	int flag = 0;

	__asm__ __volatile__ (
		"movl $0, %%eax \n\t"
        "movq $1, %%rdi \n\t"
		"syscall \n\t"
		:
		:"S"(buff), "d"(bytes)
	);

	bytes = 0;

	while(buff[bytes]!='\0' && buff[bytes]!='\n')
		bytes++;

	buff[bytes]='\0';

	if(buff[0]=='-') i = 1;
	else i = 0;

	int num = 0;

	while(i!=bytes)
	{
		char c = buff[i];
		if(c>='0' && c<='9')
		{
			num = 10*num + (c-'0');
		}
		else {
			flag = 1;
			break;
		}
		i++;
	}
	if(buff[0]=='-')
		*n = -num;
	else *n = num;


	if(flag == 1)
		return ERR;
	return OK;
}

int printStr(char *s)
{
	char buff[BUFF];
	int i=0, j, k, bytes;
	while(s[i]!='\0' && s[i]!='\n')
	{
		buff[i] = s[i];
		i++; 
	}
	buff[i]='\0';		//terminating buffer with '\0'
	bytes = i+1;
	// printing via syscall 
	__asm__ __volatile__ (
		"movl $1, %%eax \n\t"
		"movq $1, %%rdi \n\t"
		"syscall \n\t"
		:
		:"S"(buff), "d"(bytes)
	);

	return bytes;
}

int printInt(int n) 	//similar to printFlt
{
    char buff[BUFF], zero='0';
    int i=0, j, k, bytes;

    if(n == 0) buff[i++]=zero;
    else{
       if(n < 0) {
          buff[i++]='-';
          n = -n;
       }
       while(n){
          int dig = n%10;
          buff[i++] = (char)(zero+dig);
          n /= 10;
       }
       if(buff[0] == '-') j = 1;
       else j = 0;
       k=i-1;
       while(j<k){ 		//reversing buff
          char temp=buff[j];
          buff[j++] = buff[k];
          buff[k--] = temp;
       }
    } 
    buff[i]='\n';
    bytes = i+1;

    __asm__ __volatile__ (
          "movl $1, %%eax \n\t"
          "movq $1, %%rdi \n\t"
          "syscall \n\t"
          :
          :"S"(buff), "d"(bytes)
    ) ;  // $1: write, $1: on stdin

    return bytes;
}

int printFlt(float f)
{
	char buff[BUFF];
	int i = 0, j, k, bytes;

	if(f==0) buff[i++] = '0';
	else {
		
		int n = f;	//integer part of f
		
		if(n == 0) buff[i++]='0';
		else{
			if(n < 0) {
				f = -f;
				buff[i++]='-';
				n = -n;
			}
			f = f - n;	//f <- decimal part of f
			
			//getting digits one by one
			while(n){
				int dig = n%10; 
				buff[i++] = (char)('0'+dig); //int to char
				n /= 10;
			}
			if(buff[0] == '-') j = 1; //ignoring - sign
			else j = 0;
			k=i-1;
			//buff contains int in reverse order of digits and needs to be reversed
			while(j<k){
				char temp=buff[j];
				buff[j++] = buff[k];
				buff[k--] = temp;
			} 
		}
		//printing decimal part
		buff[i++] = '.';
		for(int j = 0; j<7; j++)
		{
			f*=10; 
			int dig = f; //getting 1st digit after decimal
			buff[i++] = (dig + '0');
			f -= dig; 	// f contains remaining decimal part to be printed
		}
	}
	buff[i] = '\n'; 	//terminating string
	bytes = i+1; 	//buffer length

	//printing via syscall
	__asm__ __volatile__ (
		"movl $1, %%eax \n\t" 	//eax <- 1 to print string
		"movq $1, %%rdi \n\t"	//passing argument to function
		"syscall \n\t"
		:
		:"S"(buff), "d"(bytes)	//passing buff and buff length 
	);
	return OK;
}

int readFlt(float *f)
{
	int i = 0;
	int bytes = BUFF;
	char buff[BUFF];
	int flag = 0;

	//reading via syscall
	__asm__ __volatile__ (
		"movl $0, %%eax \n\t" 	//eax <- 0 to read input
        "movq $1, %%rdi \n\t"
		"syscall \n\t"
		:
		:"S"(buff), "d"(bytes) //reading into buff with max buffer length = bytes = BUFF
	);

	bytes = 0;

	//length of buff input
	while(buff[bytes]!='\0' && buff[bytes]!='\n')
		bytes++;
	//terminating with null
	buff[bytes]='\0';

	if(buff[0]=='-') i = 1;
	else i = 0;

	float num = 0.0;
	float dec = 1.0;

	while(i!=bytes)
	{
		char c = buff[i];
		if(c=='.')
		{
			if(dec==1.0)
				dec/=10.0;
			else {			//decimal point has been encoutered earlier, so it is an invalid input
				flag = 1;
				break;
			}
		}
		else if(c>='0' && c<='9')
		{
			if(dec==1)		//integer part calculation
				num = 10*num + (c-'0');
			else {			//decimal part calculation
				num = num + (c-'0')*dec;
				dec/=10;
			} 
		}
		else {				//check for some other random character
			flag = 1;
			break;
		}
		i++;
	}

	if(buff[0]=='-')
		*f = -num;
	else *f = num;

	if(flag == 1)
		return ERR;
	return OK;
}