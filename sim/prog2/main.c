
void gray(char* image_start,char* image_end,char* store_address)
{
	for(int i=28;(&image_start+i)<&image_end;i=i+3)
	{
		*(&store_address+i)=*(&image_start+i)*0.11+*(&image_startt+i+1)*0.59+*(&image_start+i+2)*0.3;
	}
}
*
int main(void)
{
	extern char _binary_image_bmp_start;
	extern char _binary_image_bmp_end;
	extern char _test_start;
	for(int i=0;i<=53;++i)
	{
		*(&_test_start+i)=*(&_binary_image_bmp_start+i);
	}
	
	
	for(int i=54;(&_binary_image_bmp_start+i)<&_binary_image_bmp_end;i=i+3)
	{
		*(&_test_start+i)=*(&_binary_image_bmp_start+i)*0.11+*(&_binary_image_bmp_start+i+1)*0.59+*(&_binary_image_bmp_start+i+2)*0.3;
	}
	
	/*
	gray(&_binary_image_bmp_start,&_binary_image_bmp_end,&_test_start);
	*/
	return 0;
}