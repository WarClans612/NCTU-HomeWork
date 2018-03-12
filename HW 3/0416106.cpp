#include "bmpReader.h"
#include <stdio.h>
#include <iostream>
#include <math.h>
#include <sys/time.h>
#include <pthread.h>
//line 6
using namespace std;

#define MYRED	2
#define MYGREEN 1
#define MYBLUE	0

int imgWidth, imgHeight;
int BILINEAR_RATIO;
float ROTATION_ANGLE;
float SHEAR_VERTICAL_DEGREE;
float SHEAR_HORIZONTAL_DEGREE;
char *inputfile_name = "input.bmp";
char *outputfile_name[5] = { "0416106_output1.bmp", "0416106_output2.bmp", "0416106_output3.bmp", "0416106_output4.bmp", "0416106_output5.bmp"};
unsigned char *input_pic, *bilinear_pic, *rotation_pic, *shearVert_pic, *shearHori_pic, *mix_pic, *temp_pic;

unsigned char bilinear(unsigned char *pic, int w, int h, int color)
{
	int pixel = 0;
	int relevant_w = (int)(w / BILINEAR_RATIO);
	int relevant_h = (int)(h / BILINEAR_RATIO);
	int reference_points[4];

	reference_points[0] = pic[3 * (relevant_h * imgWidth + relevant_w) + color];
	reference_points[1] = pic[3 * (relevant_h * imgWidth + (relevant_w + 1)) + color];
	reference_points[2] = pic[3 * ((relevant_h + 1) * imgWidth + relevant_w) + color];
	reference_points[3] = pic[3 * ((relevant_h + 1) * imgWidth + (relevant_w + 1)) + color];

	double t = (w % BILINEAR_RATIO) / BILINEAR_RATIO;
	double u = (h % BILINEAR_RATIO) / BILINEAR_RATIO;
	double ut = u * t;
	int a = reference_points[2] - reference_points[0];
	int b = reference_points[1] - reference_points[0];
	int c = reference_points[0] - reference_points[1] - reference_points[2] + reference_points[3];
	int d = reference_points[0];

	pixel = (int)(a * t + b * u + c * ut + d);

	if (pixel < 0) pixel = 0;
	if (pixel > 255) pixel = 255;

	return (unsigned char)pixel;
}

unsigned char rotation(unsigned char *pic, int w, int h, int w_offset, int h_offset, int color)
{
	int pixel = 0;
	double angle = (double)ROTATION_ANGLE * M_PI / 180.0;
	double cos_theta = cos(angle);
	double sin_theta = sin(angle);
	int relevant_w = w - w_offset;
	int relevant_h = h - h_offset;
	int trans_w = (int)(relevant_w * cos_theta - relevant_h * sin_theta) + w_offset;
	int trans_h = (int)(relevant_h * cos_theta + relevant_w * sin_theta) + h_offset;

	if (trans_w >= 0 && trans_w < w_offset * 2 && trans_h >= 0 && trans_h < h_offset * 2)
		pixel = pic[3 * (trans_h * 2 * w_offset + trans_w) + color];

	return (unsigned char)pixel;
}

unsigned char shear_vertical(unsigned char *pic, int w, int h, int border_w, int border_h, int color)
{
	int pixel = 0;
	int h_offset = (int)(border_w * SHEAR_VERTICAL_DEGREE / 2);
	int trans_w = w;
	int trans_h = (int)(h + w * SHEAR_VERTICAL_DEGREE) - h_offset;

	if (trans_h >= 0 && trans_h < border_h)
		pixel = pic[3 * (trans_h * border_w + trans_w) + color];

	return (unsigned char)pixel;
}

unsigned char shear_horizontal(unsigned char *pic, int w, int h, int border_w, int border_h, int color)
{
	int pixel = 0;
	int w_offset = (int)(border_h * SHEAR_HORIZONTAL_DEGREE / 2);
	int trans_w = (int)(w + h * SHEAR_HORIZONTAL_DEGREE) - w_offset;
	int trans_h = h;

	if (trans_w >= 0 && trans_w < border_w)
		pixel = pic[3 * (trans_h * border_w + trans_w) + color];

	return (unsigned char)pixel;
}
//line 92
//Class for transfer between thread
class pic_object
{
    public:
        //Default Constructor
        pic_object(){}//Do nothing
        //Copy constructor
        pic_object(unsigned char *destination, unsigned char *p, int bw, int bh, int colo, int nww, int nhh)
        {
            dest = destination; pic = p; border_w = bw; border_h = bh; color = colo; nw = nww; nh = nhh;
        }
        unsigned char *pic, *dest;
        int border_w, border_h, color, nw, nh;
};

pthread_mutex_t lock_x;
void* parallel_bilinear (void *obj)
{
    pthread_mutex_lock(&lock_x);
    pic_object picture = *(pic_object*) obj;
    pthread_mutex_unlock(&lock_x);
    for(int i = 0; i < picture.nw; ++i)
        for(int j = 0; j < picture.nh; ++j)
            picture.dest[3 * (j * picture.nw + i) + picture.color] = bilinear(picture.pic, i, j, picture.color);
    pthread_exit(NULL);
}

pthread_mutex_t lock_y;
void* parallel_rotation (void *obj)
{
    pthread_mutex_lock(&lock_y);
    pic_object picture = *(pic_object*) obj;
    pthread_mutex_unlock(&lock_y);
    for(int i = 0; i < picture.nw; ++i)
        for(int j = 0; j < picture.nh; ++j)
            picture.dest[3 * (j * picture.nw + i) + picture.color] = rotation(picture.pic, i, j, picture.border_w, picture.border_h, picture.color);
    pthread_exit(NULL);
}

pthread_mutex_t lock_z;
void* parallel_shear_vertical (void *obj)
{
    pthread_mutex_lock(&lock_z);
    pic_object picture = *(pic_object*) obj;
    pthread_mutex_unlock(&lock_z);
    for(int i = 0; i < picture.nw; ++i)
        for(int j = 0; j < picture.nh; ++j)
            picture.dest[3 * (j * picture.nw + i) + picture.color] = shear_vertical(picture.pic, i, j, picture.nw, picture.nh, picture.color);
    pthread_exit(NULL);
}

pthread_mutex_t lock_a;
void* parallel_shear_horizontal (void *obj)
{
    pthread_mutex_lock(&lock_a);
    pic_object picture = *(pic_object*) obj;
    pthread_mutex_unlock(&lock_a);
    for(int i = 0; i < picture.nw; ++i)
        for(int j = 0; j < picture.nh; ++j)
            picture.dest[3 * (j * picture.nw + i) + picture.color] = shear_horizontal(picture.pic, i, j, picture.nw, picture.nh, picture.color);
    pthread_exit(NULL);
}

//Class for writer transfer
class pic_data
{
    public:
        //Default constructor
        pic_data(){}//Do nothing
        //Copy constructor
        pic_data(BmpReader* bmp, char *tf, int ta_width, int ta_height, unsigned char *tptr)
        {
            bmpreader = bmp; f = tf; a_width = ta_width; a_height = ta_height; ptr = tptr;
        }
        BmpReader* bmpreader;
        char *f;
        int a_width, a_height;
        unsigned char *ptr;
};

pthread_mutex_t lock_b;
void* parallel_writes (void *data)
{
    pthread_mutex_lock(&lock_b);
    pic_data picture = *(pic_data*) data;
    pthread_mutex_unlock(&lock_b);
    picture.bmpreader->WriteBMP(picture.f, picture.a_width, picture.a_height, picture.ptr);
    pthread_exit(NULL);
}

//line 93
int main()
{
	BmpReader* bmpReader = new BmpReader();
	struct timeval  tv1, tv2;
	int nw, nh;

	// read cfg file
	FILE* cfg;
	cfg = fopen("cfg.txt", "r");
	fscanf(cfg, "%d", &BILINEAR_RATIO);
	fscanf(cfg, "%f", &ROTATION_ANGLE);
	fscanf(cfg, "%f", &SHEAR_VERTICAL_DEGREE);
	fscanf(cfg, "%f", &SHEAR_HORIZONTAL_DEGREE);

	// timing function 1
	gettimeofday(&tv1, NULL);
	input_pic = bmpReader->ReadBMP(inputfile_name, &imgWidth, &imgHeight);
	//line 110
	nw = (int)(imgWidth * BILINEAR_RATIO);
	nh = (int)(imgHeight * BILINEAR_RATIO);

	bilinear_pic = (unsigned char*)malloc(3 * nw * nh * sizeof(unsigned char));
	rotation_pic = (unsigned char*)malloc(3 * nw * nh * sizeof(unsigned char));
	shearVert_pic = (unsigned char*)malloc(3 * nw * nh * sizeof(unsigned char));
	shearHori_pic = (unsigned char*)malloc(3 * nw * nh * sizeof(unsigned char));
	mix_pic = (unsigned char*)malloc(3 * nw * nh * sizeof(unsigned char));
	temp_pic = (unsigned char*)malloc(3 * nw * nh * sizeof(unsigned char));

	//Declaring thread for data writing
	pthread_t writer[5];

    //Declaring thread
    pthread_t bili_thr[3];
    pic_object *for_bilinear[3];
    for_bilinear[0] = new pic_object(bilinear_pic, input_pic, 0, 0, MYRED, nw, nh);
    for_bilinear[1] = new pic_object(bilinear_pic, input_pic, 0, 0, MYGREEN, nw, nh);
    for_bilinear[2] = new pic_object(bilinear_pic, input_pic, 0, 0, MYBLUE, nw, nh);
    for(int i = 0; i < 3; ++i) pthread_create(&bili_thr[i], NULL, parallel_bilinear, (void*)for_bilinear[i]);
    //wait for bilinear to finish
    for(int i = 0; i < 3; ++i) pthread_join(bili_thr[i], NULL);
    //Writing data into a file using thread
    pic_data bili(bmpReader, outputfile_name[0], nw, nh, bilinear_pic);
    pthread_create(&writer[0], NULL, parallel_writes, (void*)&bili);
    //bmpReader->WriteBMP(outputfile_name[0], nw, nh, bilinear_pic);

	int w_offset = (int)(nw / 2);
	int h_offset = (int)(nh / 2);
    //Declaring thread
    pthread_t shear_ver_thr[3];
	pic_object *for_shearVert[3];
	for_shearVert[0] = new pic_object(shearVert_pic, bilinear_pic, 0, 0, MYRED, nw, nh);
	for_shearVert[1] = new pic_object(shearVert_pic, bilinear_pic, 0, 0, MYGREEN, nw, nh);
	for_shearVert[2] = new pic_object(shearVert_pic,bilinear_pic, 0, 0, MYBLUE, nw, nh);
    for(int i = 0; i < 3; ++i) pthread_create(&shear_ver_thr[i], NULL, parallel_shear_vertical, (void*)for_shearVert[i]);

    //Declaring thread
    pthread_t shear_hor_thr[3];
	pic_object *for_shearHori[3];
	for_shearHori[0] = new pic_object(shearHori_pic, bilinear_pic, 0, 0, MYRED, nw, nh);
	for_shearHori[1] = new pic_object(shearHori_pic, bilinear_pic, 0, 0, MYGREEN, nw, nh);
	for_shearHori[2] = new pic_object(shearHori_pic,bilinear_pic, 0, 0, MYBLUE, nw, nh);
    for(int i = 0; i < 3; ++i) pthread_create(&shear_hor_thr[i], NULL, parallel_shear_horizontal, (void*)for_shearHori[i]);

    //Declaring thread
	pthread_t rotate_thr[3];
    pic_object *for_second[3];
    for_second[0] = new pic_object(rotation_pic, bilinear_pic, w_offset, h_offset, MYRED, nw, nh);
    for_second[1] = new pic_object(rotation_pic, bilinear_pic, w_offset, h_offset, MYGREEN, nw, nh);
    for_second[2] = new pic_object(rotation_pic, bilinear_pic, w_offset, h_offset, MYBLUE, nw, nh);
    for(int i = 0; i < 3; ++i) pthread_create(&rotate_thr[i], NULL, parallel_rotation, (void*)for_second[i]);

    //Wait for shear vertical to finish
    for(int i = 0; i < 3; ++i) pthread_join(shear_ver_thr[i], NULL);
    //Writing data into a file using thread
    pic_data shearver(bmpReader, outputfile_name[2], nw, nh, shearVert_pic);
    pthread_create(&writer[2], NULL, parallel_writes, (void*)&shearver);
    //bmpReader->WriteBMP(outputfile_name[2], nw, nh, shearVert_pic);

    //Declaring thread
	pthread_t rotate_temp[3];
    pic_object *for_temp[3];
    for_temp[0] = new pic_object(temp_pic, shearVert_pic, w_offset, h_offset, MYRED, nw, nh);
    for_temp[1] = new pic_object(temp_pic, shearVert_pic, w_offset, h_offset, MYGREEN, nw, nh);
    for_temp[2] = new pic_object(temp_pic, shearVert_pic, w_offset, h_offset, MYBLUE, nw, nh);
    for(int i = 0; i < 3; ++i) pthread_create(&rotate_temp[i], NULL, parallel_rotation, (void*)for_temp[i]);
    //Wait for temp pic to finish
    for(int i = 0; i < 3; ++i) pthread_join(rotate_temp[i], NULL);

    //Declaring thread
	pthread_t shear_mix[3];
	pic_object *for_mix[3];
	for_mix[0] = new pic_object(mix_pic, temp_pic, nw, nh, MYRED, nw, nh);
	for_mix[1] = new pic_object(mix_pic, temp_pic, nw, nh, MYGREEN, nw, nh);
	for_mix[2] = new pic_object(mix_pic,temp_pic, nw, nh, MYBLUE, nw, nh);
    for(int i = 0; i < 3; ++i) pthread_create(&shear_mix[i], NULL, parallel_shear_horizontal, (void*)for_mix[i]);

    //Write it into a file
	for(int i = 0; i < 3; ++i) pthread_join(shear_hor_thr[i], NULL);
    //Writing data into a file using thread
    pic_data shearhor(bmpReader, outputfile_name[3], nw, nh, shearHori_pic);
    pthread_create(&writer[3], NULL, parallel_writes, (void*)&shearhor);
	//bmpReader->WriteBMP(outputfile_name[3], nw, nh, shearHori_pic);
    for(int i = 0; i < 3; ++i) pthread_join(rotate_thr[i], NULL);
    //Writing data into a file using thread
    pic_data rota(bmpReader, outputfile_name[1], nw, nh, rotation_pic);
    pthread_create(&writer[1], NULL, parallel_writes, (void*)&rota);
	//bmpReader->WriteBMP(outputfile_name[1], nw, nh, rotation_pic);
	for(int i = 0; i < 3; ++i) pthread_join(shear_mix[i], NULL);
    //Writing data into a file using thread
    pic_data mixs(bmpReader, outputfile_name[4], nw, nh, mix_pic);
    pthread_create(&writer[4], NULL, parallel_writes, (void*)&mixs);
	//bmpReader->WriteBMP(outputfile_name[4], nw, nh, mix_pic);

	//Wait for all writing thread to finish
	for(int i = 0; i < 5; ++i) pthread_join(writer[i], NULL);
	//line 177
	free(input_pic);
	free(bilinear_pic);
	free(rotation_pic);
	free(shearVert_pic);
	free(shearHori_pic);
	free(mix_pic);
	free(temp_pic);

	// timing function 2
	gettimeofday(&tv2, NULL);
	printf("0416106 %f seconds\n", (double)(tv2.tv_usec - tv1.tv_usec) / 1000000 + (double)(tv2.tv_sec - tv1.tv_sec)); //(line 188) modify 0316001 to your student ID

	return 0;
}
