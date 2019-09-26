#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <opencv2/opencv.hpp>
#include "image.h"
#include "filter.h"

#define TILE_WIDTH 32
#define TILE_HEIGHT 32
#define FSize 256
//void convolution(int *InputImage,int width,int height,int *filter,int filterWidth,,int padding,int *result);
using namespace std;

__global__ void MatrixMultiple(int *InputImage,int width,int height,int *filter,int filterWidth,int *featureMap);
int* pad_array(int* input, int width, int height, int padding);
__constant__ int cntfilterd[FSize];


#define gpuErrchk(ans) { gpuAssert((ans), __FILE__, __LINE__); }
inline void gpuAssert(cudaError_t code, const char *file, int line, bool abort=true)
{
   if (code != cudaSuccess)
   {
      fprintf(stderr,"GPUassert: %s %s %d\n", cudaGetErrorString(code), file, line);
      if (abort) exit(code);
   }
}

/* one feature map element map to one thread*/
__global__ void MatrixMultiple(int *InputImage,int width,int height,int *filter,int filterWidth,int *featureMap)
{
    /* get global row col */
    int Row=blockIdx.y*TILE_HEIGHT+threadIdx.y;
    int Col=blockIdx.x*TILE_WIDTH+threadIdx.x;
    int value=0;
    int feathreMapwidth=width-filterWidth+1;
    if(Row*width+Col<width*height)
    {
        for(int i=0;i<filterWidth;i++)
        {
            for(int j=0;j<filterWidth;j++)
            {
                value+=filter[i*filterWidth+j]* InputImage[(Row+i)*width+Col+j];
            }
        }
        //printf("%d %d\n",Row*width+Col,value);

        featureMap[feathreMapwidth*Row+Col]=value;
    }
    //printf("%d %d\n",Row*width+Col,value);
}
__global__ void cntMatrixMultiple(int *InputImage,int width,int height,int filterWidth,int *featureMap)
{
    /* get global row col */
    int Row=blockIdx.y*TILE_HEIGHT+threadIdx.y;
    int Col=blockIdx.x*TILE_WIDTH+threadIdx.x;
    int value=0;
    int feathreMapwidth=width-filterWidth+1;
    if(Row*width+Col<width*height)
    {
        for(int i=0;i<filterWidth;i++)
        {
            for(int j=0;j<filterWidth;j++)
            {
                value+=cntfilterd[i*filterWidth+j]* InputImage[(Row+i)*width+Col+j];
            }
        }
        //printf("%d %d\n",Row*width+Col,value);

        featureMap[feathreMapwidth*Row+Col]=value;
    }
    //printf("%d %d\n",Row*width+Col,value);
}
__global__ void sharecntMatrixMultiple(int *InputImage,int width,int height,int filterWidth,int *featureMap)
{
    extern __shared__ int tileImage[];

    int Row=blockIdx.y*TILE_HEIGHT+threadIdx.y;
    int Col=blockIdx.x*TILE_WIDTH+threadIdx.x;
    int value=0;
    int feathreMapwidth=width-filterWidth+1;
    int shareWidth=(TILE_WIDTH+filterWidth-1);

    tileImage[threadIdx.y*shareWidth+threadIdx.x]=InputImage[Row*width+Col];
    if(threadIdx.x<filterWidth-1)
    {
        tileImage[threadIdx.y*shareWidth+threadIdx.x+TILE_WIDTH]=InputImage[Row*width+Col+TILE_WIDTH];
    }
    if(threadIdx.y<filterWidth-1)
    {
        tileImage[(threadIdx.y+TILE_HEIGHT)*shareWidth+threadIdx.x]=InputImage[(Row+TILE_HEIGHT)*width+Col];
    }
    if(threadIdx.x<filterWidth-1 && threadIdx.y<filterWidth-1)
    {
        tileImage[(threadIdx.y+TILE_HEIGHT)*shareWidth+threadIdx.x+TILE_WIDTH]=InputImage[(Row+TILE_HEIGHT)*width+Col+TILE_WIDTH];
    }
    
    __syncthreads();

    if(Row*width+Col<width*height)
    {
        for(int i=0;i<filterWidth;i++)
        {
            for(int j=0;j<filterWidth;j++)
            {
                //value+=filter[i*filterWidth+j]* InputImage[(Row+i)*width+Col+j];
                value+=cntfilterd[i*filterWidth+j]* tileImage[(threadIdx.y+i)*shareWidth+threadIdx.x+j];
            }
        }
        //printf("%d %d\n",Row*width+Col,value);
        featureMap[feathreMapwidth*Row+Col]=value;
    }
}
__global__ void shareMatrixMultiple(int *InputImage,int width,int height,int *filter,int filterWidth,int *featureMap)
{
    extern __shared__ int tileImage[];

    int Row=blockIdx.y*TILE_HEIGHT+threadIdx.y;
    int Col=blockIdx.x*TILE_WIDTH+threadIdx.x;
    int value=0;
    int feathreMapwidth=width-filterWidth+1;
    int shareWidth=(TILE_WIDTH+filterWidth-1);

    tileImage[threadIdx.y*shareWidth+threadIdx.x]=InputImage[Row*width+Col];
    if(threadIdx.x<filterWidth-1)
    {
        tileImage[threadIdx.y*shareWidth+threadIdx.x+TILE_WIDTH]=InputImage[Row*width+Col+TILE_WIDTH];
    }
    if(threadIdx.y<filterWidth-1)
    {
        tileImage[(threadIdx.y+TILE_HEIGHT)*shareWidth+threadIdx.x]=InputImage[(Row+TILE_HEIGHT)*width+Col];
    }
    if(threadIdx.x<filterWidth-1 && threadIdx.y<filterWidth-1)
    {
        tileImage[(threadIdx.y+TILE_HEIGHT)*shareWidth+threadIdx.x+TILE_WIDTH]=InputImage[(Row+TILE_HEIGHT)*width+Col+TILE_WIDTH];
    }
    
    __syncthreads();

    if(Row*width+Col<width*height)
    {
        for(int i=0;i<filterWidth;i++)
        {
            for(int j=0;j<filterWidth;j++)
            {
                //value+=filter[i*filterWidth+j]* InputImage[(Row+i)*width+Col+j];
                value+=filter[i*filterWidth+j]* tileImage[(threadIdx.y+i)*shareWidth+threadIdx.x+j];
            }
        }
        //printf("%d %d\n",Row*width+Col,value);
        featureMap[feathreMapwidth*Row+Col]=value;
    }
}
int * sharecntconvolution(int *OriginImage,int width,int height,int *filter,int filterWidth,int padding,int *result)
{

    int *featureMapd,*InputImaged,*filterd,*featureMap,*afterpadding,*InputImage;
    int x,y,featureMapWidth,featureMapHeight;
    int paddingImageSize=(width+padding*2)*(height+padding*2)*sizeof(int);
    int filterSize=filterWidth*filterWidth*sizeof(int);
    int feathreMapSize;
    //cout<<"in share+constant convolution"<<endl;
    featureMapHeight=height; //feature map's width = origin width-featureWidth+1
    featureMapWidth=width;
    feathreMapSize=featureMapHeight*featureMapWidth*sizeof(int);
    InputImage= pad_array(OriginImage,width,height,padding);
    featureMap= new int[feathreMapSize];
    /*for(int i=0;i<width*height;i++)
    {
        //cout<<i<<" "<<InputImage[i]<<endl;
    }*/
    cudaMalloc(&InputImaged,paddingImageSize);
    cudaMemcpy(InputImaged,InputImage,paddingImageSize,cudaMemcpyHostToDevice);

    cudaMemcpyToSymbol(cntfilterd, filter, sizeof(int) * FSize);

    cudaMalloc(&featureMapd,feathreMapSize);

    //cout<<"in"<<endl;
    // determine which blocks
    x=(featureMapWidth+TILE_WIDTH-1)/TILE_WIDTH;
    y=(featureMapHeight+TILE_HEIGHT-1)/TILE_HEIGHT;

    //cout<<x<<" "<<y<<endl;
    dim3 dimGrid(x,y);
    dim3 dimBlock(TILE_WIDTH,TILE_HEIGHT);

    int Sharesize=(TILE_WIDTH+filterWidth-1)*(TILE_HEIGHT+filterWidth-1);
    sharecntMatrixMultiple<<<dimGrid,dimBlock, Sharesize*sizeof(int)>>>(InputImaged,width+padding*2,height+padding*2,filterWidth,featureMapd);

    gpuErrchk( cudaPeekAtLastError() );
    gpuErrchk( cudaDeviceSynchronize() );
    cudaMemcpy(featureMap,featureMapd,feathreMapSize,cudaMemcpyDeviceToHost);
    /*for(int i=0;i<featureMapHeight*featureMapWidth;i++)
    {
        //cout<<i<<" "<<featureMap[i]<<endl;
    }*/
    cudaFree(featureMapd);cudaFree(InputImaged);//cudaFree(filterd);
    delete [] InputImage;

    return featureMap;

    /*for(int i=0;i<width*height;i++)
    {
        //cout<<i<<" "<<result[i]<<endl;
    }*/
}
int *cntconvolution(int *OriginImage,int width,int height,int *filter,int filterWidth,int padding,int *result)
{

    int *featureMapd,*InputImaged,*filterd,*featureMap,*afterpadding,*InputImage;
    int x,y,featureMapWidth,featureMapHeight;
    int paddingImageSize=(width+padding*2)*(height+padding*2)*sizeof(int);
    int filterSize=filterWidth*filterWidth*sizeof(int);
    int feathreMapSize;
    //cout<<"in constant convolution"<<endl;
    featureMapHeight=height; //feature map's width = origin width-featureWidth+1
    featureMapWidth=width;
    feathreMapSize=featureMapHeight*featureMapWidth*sizeof(int);
    InputImage= pad_array(OriginImage,width,height,padding);
    featureMap= new int[feathreMapSize];
    /*for(int i=0;i<width*height;i++)
    {
        //cout<<i<<" "<<InputImage[i]<<endl;
    }*/
    cudaMalloc(&InputImaged,paddingImageSize);
    cudaMemcpy(InputImaged,InputImage,paddingImageSize,cudaMemcpyHostToDevice);

    cudaMemcpyToSymbol(cntfilterd, filter, sizeof(int) * FSize);

    cudaMalloc(&featureMapd,feathreMapSize);

    //cout<<"in"<<endl;
    // determine which blocks
    x=(featureMapWidth+TILE_WIDTH-1)/TILE_WIDTH;
    y=(featureMapHeight+TILE_HEIGHT-1)/TILE_HEIGHT;

    //cout<<x<<" "<<y<<endl;
    dim3 dimGrid(x,y);
    dim3 dimBlock(TILE_WIDTH,TILE_HEIGHT);

    cntMatrixMultiple<<<dimGrid,dimBlock>>>(InputImaged,width+padding*2,height+padding*2,filterWidth,featureMapd);
    gpuErrchk( cudaPeekAtLastError() );
    gpuErrchk( cudaDeviceSynchronize() );
    cudaMemcpy(featureMap,featureMapd,feathreMapSize,cudaMemcpyDeviceToHost);
    /*for(int i=0;i<featureMapHeight*featureMapWidth;i++)
    {
        //cout<<i<<" "<<featureMap[i]<<endl;
    }*/
    cudaFree(featureMapd);cudaFree(InputImaged);//cudaFree(filterd);
    delete [] InputImage;

    return featureMap;
}

int * convolution(int *OriginImage,int width,int height,int *filter,int filterWidth,int padding,int *result)
{

    int *featureMapd,*InputImaged,*filterd,*featureMap,*afterpadding,*InputImage;
    int x,y,featureMapWidth,featureMapHeight;
    int paddingImageSize=(width+padding*2)*(height+padding*2)*sizeof(int);
    int filterSize=filterWidth*filterWidth*sizeof(int);
    int feathreMapSize;
    //cout<<"in normal convolution"<<endl;
    featureMapHeight=height; //feature map's width = origin width-featureWidth+1
    featureMapWidth=width;
    feathreMapSize=featureMapHeight*featureMapWidth*sizeof(int);
    InputImage= pad_array(OriginImage,width,height,padding);
    featureMap= new int[feathreMapSize];
    /*for(int i=0;i<width*height;i++)
    {
        //cout<<i<<" "<<InputImage[i]<<endl;
    }*/
    cudaMalloc(&InputImaged,paddingImageSize);
    cudaMemcpy(InputImaged,InputImage,paddingImageSize,cudaMemcpyHostToDevice);

    cudaMalloc(&filterd,filterSize);
    cudaMemcpy(filterd,filter,filterSize,cudaMemcpyHostToDevice);

    cudaMalloc(&featureMapd,feathreMapSize);

    //cout<<"in"<<endl;
    // determine which blocks
    x=(featureMapWidth+TILE_WIDTH-1)/TILE_WIDTH;
    y=(featureMapHeight+TILE_HEIGHT-1)/TILE_HEIGHT;

    //cout<<x<<" "<<y<<endl;
    dim3 dimGrid(x,y);
    dim3 dimBlock(TILE_WIDTH,TILE_HEIGHT);

    MatrixMultiple<<<dimGrid,dimBlock>>>(InputImaged,width+padding*2,height+padding*2,filterd,filterWidth,featureMapd);
    gpuErrchk( cudaPeekAtLastError() );
    gpuErrchk( cudaDeviceSynchronize() );
    cudaMemcpy(featureMap,featureMapd,feathreMapSize,cudaMemcpyDeviceToHost);
    /*for(int i=0;i<featureMapHeight*featureMapWidth;i++)
    {
        //cout<<i<<" "<<featureMap[i]<<endl;
    }*/
    cudaFree(featureMapd);cudaFree(InputImaged);cudaFree(filterd);
    delete [] InputImage;

    return featureMap;

    /*for(int i=0;i<width*height;i++)
    {
        //cout<<i<<" "<<result[i]<<endl;
    }*/
}

int * shareconvolution(int *OriginImage,int width,int height,int *filter,int filterWidth,int padding,int *result)
{

    int *featureMapd,*InputImaged,*filterd,*featureMap,*afterpadding,*InputImage;
    int x,y,featureMapWidth,featureMapHeight;
    int paddingImageSize=(width+padding*2)*(height+padding*2)*sizeof(int);
    int filterSize=filterWidth*filterWidth*sizeof(int);
    int feathreMapSize;
    //cout<<"in share convolution"<<endl;
    featureMapHeight=height; //feature map's width = origin width-featureWidth+1
    featureMapWidth=width;
    feathreMapSize=featureMapHeight*featureMapWidth*sizeof(int);
    InputImage= pad_array(OriginImage,width,height,padding);
    featureMap= new int[feathreMapSize];
    /*for(int i=0;i<width*height;i++)
    {
        //cout<<i<<" "<<InputImage[i]<<endl;
    }*/
    cudaMalloc(&InputImaged,paddingImageSize);
    cudaMemcpy(InputImaged,InputImage,paddingImageSize,cudaMemcpyHostToDevice);

    cudaMalloc(&filterd,filterSize);
    cudaMemcpy(filterd,filter,filterSize,cudaMemcpyHostToDevice);

    cudaMalloc(&featureMapd,feathreMapSize);

    //cout<<"in"<<endl;
    // determine which blocks
    x=(featureMapWidth+TILE_WIDTH-1)/TILE_WIDTH;
    y=(featureMapHeight+TILE_HEIGHT-1)/TILE_HEIGHT;

    //cout<<x<<" "<<y<<endl;
    dim3 dimGrid(x,y);
    dim3 dimBlock(TILE_WIDTH,TILE_HEIGHT);

    int Sharesize=(TILE_WIDTH+filterWidth-1)*(TILE_HEIGHT+filterWidth-1);
    shareMatrixMultiple<<<dimGrid,dimBlock, Sharesize*sizeof(int)>>>(InputImaged,width+padding*2,height+padding*2,filterd,filterWidth,featureMapd);
    gpuErrchk( cudaPeekAtLastError() );
    gpuErrchk( cudaDeviceSynchronize() );
    cudaMemcpy(featureMap,featureMapd,feathreMapSize,cudaMemcpyDeviceToHost);
    /*for(int i=0;i<featureMapHeight*featureMapWidth;i++)
    {
        //cout<<i<<" "<<featureMap[i]<<endl;
    }*/
    cudaFree(featureMapd);cudaFree(InputImaged);cudaFree(filterd);
    delete [] InputImage;

    return featureMap;
}

int * share2convolution(int *OriginImage,int width,int height,int *filter,int filterWidth,int padding,int *result)
{

    int *featureMapd,*InputImaged,*filterd,*featureMap,*afterpadding,*InputImage;
    int x,y,featureMapWidth,featureMapHeight;
    int paddingImageSize=(width+padding*2)*(height+padding*2)*sizeof(int);
    int filterSize=filterWidth*filterWidth*sizeof(int);
    int feathreMapSize;
    //cout<<"in share convolution ver.2"<<endl;
    featureMapHeight=height; //feature map's width = origin width-featureWidth+1
    featureMapWidth=width;
    feathreMapSize=featureMapHeight*featureMapWidth*sizeof(int);
    InputImage= pad_array(OriginImage,width,height,padding);
    featureMap= new int[feathreMapSize];
    
    
    cudaMalloc(&InputImaged,paddingImageSize);
    cudaMemcpy(InputImaged,InputImage,paddingImageSize,cudaMemcpyHostToDevice);

    cudaMalloc(&filterd,filterSize);
    cudaMemcpy(filterd,filter,filterSize,cudaMemcpyHostToDevice);

    cudaMalloc(&featureMapd,feathreMapSize);

    //cout<<"in"<<endl;
    // determine which blocks
    x=(featureMapWidth+TILE_WIDTH-1)/TILE_WIDTH;
    y=(featureMapHeight+TILE_HEIGHT-1)/TILE_HEIGHT;

    //cout<<x<<" "<<y<<endl;
    dim3 dimGrid(x,y);
    dim3 dimBlock(TILE_WIDTH,TILE_HEIGHT);

    int Sharesize=(TILE_WIDTH+filterWidth-1)*(TILE_HEIGHT+filterWidth-1);
    shareMatrixMultiple<<<dimGrid,dimBlock, Sharesize*sizeof(int)>>>(InputImaged,width+padding*2,height+padding*2,filterd,filterWidth,featureMapd);
    gpuErrchk( cudaPeekAtLastError() );
    gpuErrchk( cudaDeviceSynchronize() );
    cudaMemcpy(featureMap,featureMapd,feathreMapSize,cudaMemcpyDeviceToHost);
    /*for(int i=0;i<featureMapHeight*featureMapWidth;i++)
    {
        //cout<<i<<" "<<featureMap[i]<<endl;
    }*/
    cudaFree(featureMapd);cudaFree(InputImaged);cudaFree(filterd);
    delete [] InputImage;

    return featureMap;
}

int main(int argc, char *argv[])
{
	if(argc < 4) {
        printf("Usage: ./serial_m <image_filename> <filter_filename> <mode>\n");
        return 0;
    }

    int *image_r, *image_g, *image_b;
    int image_width, image_height;
    int mode= atoi(argv[3]);

    if(read_image(argv[1], &image_r, &image_g, &image_b, &image_width, &image_height) < 0) {
        printf("Error: can not open %s\n", argv[1]);
        return -1;
    }

    //----------------------------------------------------------------------------------------
    int num_filters;
    int *fil_size;
    int **fil_matrix;
    load_filter(argv[2], &num_filters, &fil_matrix, &fil_size);

    printf("\n******************************************\n");
    printf("Do convolution\n");

    int *conv_r, *conv_g, *conv_b;
    for (int k = 0; k < 100; ++k) 
    if(mode==0)
    {
        for(int i = 0; i < num_filters; i++)
        {
            //printf("filter %d:\n", i);
            //print_filter(fil_matrix[i], fil_size[i]);
    
            conv_r=convolution(image_r,image_width,image_height,fil_matrix[i],fil_size[i],(fil_size[i]-1)/2,conv_r);
            conv_g=convolution(image_g,image_width,image_height,fil_matrix[i],fil_size[i],(fil_size[i]-1)/2,conv_g);
            conv_b=convolution(image_b,image_width,image_height,fil_matrix[i],fil_size[i],(fil_size[i]-1)/2,conv_b);
            //show_image(conv_r, conv_g, conv_b, image_width, image_height);
    
            free_image(conv_r, conv_g, conv_b);
        }
    }
    else if(mode==1)
    {
        for(int i = 0; i < num_filters; i++)
        {
            //printf("filter %d:\n", i);
            //print_filter(fil_matrix[i], fil_size[i]);
    
            conv_r=cntconvolution(image_r,image_width,image_height,fil_matrix[i],fil_size[i],(fil_size[i]-1)/2,conv_r);
            conv_g=cntconvolution(image_g,image_width,image_height,fil_matrix[i],fil_size[i],(fil_size[i]-1)/2,conv_g);
            conv_b=cntconvolution(image_b,image_width,image_height,fil_matrix[i],fil_size[i],(fil_size[i]-1)/2,conv_b);
            //show_image(conv_r, conv_g, conv_b, image_width, image_height);
    
            free_image(conv_r, conv_g, conv_b);
        }
    }
    else if(mode==2)
    {
        for(int i = 0; i < num_filters; i++)
        {
            //printf("filter %d:\n", i);
            //print_filter(fil_matrix[i], fil_size[i]);
    
            conv_r=shareconvolution(image_r,image_width,image_height,fil_matrix[i],fil_size[i],(fil_size[i]-1)/2,conv_r);
            conv_g=shareconvolution(image_g,image_width,image_height,fil_matrix[i],fil_size[i],(fil_size[i]-1)/2,conv_g);
            conv_b=shareconvolution(image_b,image_width,image_height,fil_matrix[i],fil_size[i],(fil_size[i]-1)/2,conv_b);
            //show_image(conv_r, conv_g, conv_b, image_width, image_height);
    
            free_image(conv_r, conv_g, conv_b);
        }
    }
    else if(mode==3)
    {
        for(int i = 0; i < num_filters; i++)
        {
            //printf("filter %d:\n", i);
            //print_filter(fil_matrix[i], fil_size[i]);
    
            conv_r=sharecntconvolution(image_r,image_width,image_height,fil_matrix[i],fil_size[i],(fil_size[i]-1)/2,conv_r);
            conv_g=sharecntconvolution(image_g,image_width,image_height,fil_matrix[i],fil_size[i],(fil_size[i]-1)/2,conv_g);
            conv_b=sharecntconvolution(image_b,image_width,image_height,fil_matrix[i],fil_size[i],(fil_size[i]-1)/2,conv_b);
            //show_image(conv_r, conv_g, conv_b, image_width, image_height);
    
            free_image(conv_r, conv_g, conv_b);
        }
    }
    // for(int i = 0; i < num_filters; i++)
    // {
    //     printf("filter %d:\n", i);
    //     print_filter(fil_matrix[i], fil_size[i]);

    //     conv_r=shareconvolution(image_r,image_width,image_height,fil_matrix[i],fil_size[i],(fil_size[i]-1)/2,conv_r);
    //     conv_g=shareconvolution(image_g,image_width,image_height,fil_matrix[i],fil_size[i],(fil_size[i]-1)/2,conv_g);
    //     conv_b=shareconvolution(image_b,image_width,image_height,fil_matrix[i],fil_size[i],(fil_size[i]-1)/2,conv_b);
    //     show_image(conv_r, conv_g, conv_b, image_width, image_height);

    //     free_image(conv_r, conv_g, conv_b);
    // }

    printf("Convolution done.\n");
    printf("******************************************\n");

    free_image(image_r, image_g, image_b);
    free_filter(num_filters, fil_matrix, fil_size);
    printf("\ndone.\n");
    return 0;
}


int* pad_array(int* input, int width, int height, int padding) {
    int new_width = width+2*padding;
    int new_height = height+2*padding;
    int* padded_array = new int [new_width * new_height * sizeof(int)];
    memset (padded_array, 0, new_width * new_height * sizeof(int));

    for(int i = padding; i < new_height-padding; ++i) {
        for(int j = padding; j < new_width-padding; ++j) {
            *(padded_array+i*new_width+j) = *(input+(i-padding)*width+(j-padding));
        }
    }

    return padded_array;
}

/* unfinished */



/*unfinished*/
