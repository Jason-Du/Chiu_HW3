int main(void)
{
	extern short _binary_image_bmp_start;
	extern short _binary_image_bmp_end;
	extern short _test_start;
	for(int i=0;(&_binary_image_bmp_start+i)<&_binary_image_bmp_end;++i)
	{
		if(i<54)
		{
			*(&_test_start+i)=*(&_binary_image_bmp_end+i);
		}
		else
		{
			*(&_test_start+i)=*(&_binary_image_bmp_end+i)*0.11+*(&_binary_image_bmp_end+i+1)*0.59+*(&_binary_image_bmp_end+i+2)*0.3;
		}
	}
	return 0;
}