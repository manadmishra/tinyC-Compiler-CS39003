#include <stdio.h>
#include "myl.h"


int main()
{

	int n;
	float f;
	printStr("Enter the integer: ");
	readInt(&n);
	printStr("Enter the float: ");
	readFlt(&f);

	printStr("The integer is ");
	printInt(n);

	printStr("The float is ");
	printFlt(f);
}