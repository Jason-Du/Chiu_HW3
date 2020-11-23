
int main(void)
{

	extern char _binary_image_bmp_start;
	extern int _binary_image_bmp_size;

	extern char _test_start;

	for(int i=0;i<54;i++)
	{
		*(&_test_start+i)=*(&_binary_image_bmp_start+i);
	}
	for(int i=54;i<&_binary_image_bmp_size;i=i+3)
	{
		*((&_test_start)+i)=(*(&_binary_image_bmp_start+i)*11+*(&_binary_image_bmp_start+i+1)*59+*(&_binary_image_bmp_start+i+2)*30)/100;
		*((&_test_start)+i+1)=(*(&_binary_image_bmp_start+i)*11+*(&_binary_image_bmp_start+i+1)*59+*(&_binary_image_bmp_start+i+2)*30)/100;
		*((&_test_start)+i+2)=(*(&_binary_image_bmp_start+i)*11+*(&_binary_image_bmp_start+i+1)*59+*(&_binary_image_bmp_start+i+2)*30)/100;
	}

	return 0;

	
}

