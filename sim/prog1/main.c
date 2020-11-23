
int main(void)
{
	
	extern  int  array_size;
	extern short signed int array_addr;

	extern short signed int _test_start;
	int number=*(&(array_size));
	
	int i=0;
	int j=0;
	
	short signed int temp =0;
	
	for (i=0; i <number ;++i)
	{
		for (j=0; j <number; ++j)
		{
			if (  (*(&(array_addr)+j) )  >  ( *(&(array_addr)+i) )  ) 
			{
				temp=*(&(array_addr)+j);
				*(&(array_addr)+j)=*(&(array_addr)+i);
				*(&(array_addr)+i)=temp;
			}
			
		}
	}

	for (i=0; i <number; ++i)
	{
	
		*(&(_test_start)+i)= *(&(array_addr)+i);
		
	}
	return 0;
}