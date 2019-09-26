#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <omp.h>
#include <opencv2/opencv.hpp>
#include <sys/time.h>
#include "image.h"
#include "filter.h"
using namespace std;

static int num_threads;

/*----------------------------------------------------------------------------------------
    Matrix dot product calculation
    Input matrix is expected to be 1-dimensional
    matA and matB is input picture matrix and filter matrix
    s_width and s_height is expected to be coordinate is the picture,
    where the upper left is the starting coordinate of the calculation
    Width represent the width of input picture matrix
    Boundary check will not be done, so caller is expected to check beforehand
----------------------------------------------------------------------------------------*/
int dot_product(int* matA, int* matB, int size, int s_width, int s_height, int width) {
    int answer_sum = 0;
    for(int i = 0; i < size; ++i) {
        for(int j = 0; j < size; ++j) {
            answer_sum += matA[(s_height+i)*width + s_width+j] * matB[i*size + j];
        }
    }
    return answer_sum;
}

/*----------------------------------------------------------------------------------------
    Function to pad array
    Returned a malloc array of appropriate size
    Need to be freed by caller
----------------------------------------------------------------------------------------*/
int* pad_array(int* input, int width, int height, int padding) {
    int new_width = width+2*padding;
    int new_height = height+2*padding;
    int* padded_array = new int [new_width * new_height * sizeof(int)];
    memset(padded_array, 0, new_width * new_height * sizeof(int));

    for(int i = padding; i < new_height-padding; ++i) {
        for(int j = padding; j < new_width-padding; ++j) {
            *(padded_array+i*new_width+j) = *(input+(i-padding)*width+(j-padding));
        }
    }
    return padded_array;
}

/*----------------------------------------------------------------------------------------
    Single layer of convolutional layer
----------------------------------------------------------------------------------------*/
int* conv_layer(int* matA, int* matB, int a_width, int a_height, int b_size, int padding = 0, int step_size = 1) {
    int* inputA;

    if (padding == 0) {
        inputA = matA;
    }
    else {
        inputA = pad_array(matA, a_width, a_height, padding);
    }

    int new_width = a_width + 2*padding;
    int ans_width = (new_width-b_size)/step_size + 1;
    int new_height = a_height + 2*padding;
    int ans_height = (new_height-b_size)/step_size + 1;
    int* answer = new int [ans_width * ans_height * sizeof(int)];

    #pragma omp parallel for
    for(int i = 0; i < ans_height; ++i) {
        for(int j = 0; j < ans_width; ++j) {
            answer[i*ans_width + j] = dot_product(inputA, matB, b_size, j*step_size, i*step_size, new_width);
        }
    }

    if (padding != 0) {
        delete [] inputA;
    }
    return answer;
}

int main(int argc, char** argv) {

    if(argc < 4) {
        printf("Usage: ./thread_m <image_filename> <filter_filename> <number_of_threads>\n");
        return 0;
    }

    num_threads = atoi(argv[3]);
    omp_set_num_threads(num_threads);

    int *image_r, *image_g, *image_b;
    int image_width, image_height;

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

    char filename[256];
    int *conv_r, *conv_g, *conv_b;

    //#pragma omp parallel for private(conv_r, conv_g, conv_b, filename)
    //#pragma omp parallel for private(conv_r, conv_g, conv_b)
    for(int i = 0; i < num_filters; i++)
    {
        conv_r = conv_layer(image_r, fil_matrix[i], image_width, image_height, fil_size[i], (fil_size[i]-1) / 2);
        conv_g = conv_layer(image_g, fil_matrix[i], image_width, image_height, fil_size[i], (fil_size[i]-1) / 2);
        conv_b = conv_layer(image_b, fil_matrix[i], image_width, image_height, fil_size[i], (fil_size[i]-1) / 2);

        //sprintf(filename, "thread_out%d.jpg", i);
        //write_image(filename, conv_r, conv_g, conv_b, image_width, image_height);
        free_image(conv_r, conv_g, conv_b);
    }

    printf("Convolution done.\n");
    printf("******************************************\n");

    //-----------------------------------------------------
    free_image(image_r, image_g, image_b);
    free_filter(num_filters, fil_matrix, fil_size);

    printf("done.\n");
    return 0;
}
