#include <opencv2/opencv.hpp>
#include <cstdlib>
#include "image.h"
using namespace cv;

/*--------------------------------------------------------------------------------------
    Allocate three 1D array: r, g, b which store the RGB value of the image.
    Need to call free_image(r, g, b) to free the memory.
    The width & height value of the image will assign to the parameter width & height
----------------------------------------------------------------------------------------*/
int read_image(char *filename, int **r, int **g, int **b, int *width, int *height)
{
    Mat image;
    int image_size;

    image = imread(filename, IMREAD_COLOR);

    if(!image.data)
    {
        printf("No image data\n");
        return -1;
    }

    printf("\n******************************************\n");
    printf("Opening %s\n", filename);
    printf("Read image width:  %d\n", image.cols);
    printf("Read image height: %d\n", image.rows);

    *width = image.cols;
    *height = image.rows;
    image_size = image.cols * image.rows;


    *r = new int [image_size * sizeof(int)];
    *g = new int [image_size * sizeof(int)];
    *b = new int [image_size * sizeof(int)];

    for(int i = 0; i < *height; i++)
    {
        for(int j = 0; j < *width; j++)
        {
            // OpenCV is BGR
            (*b)[i*image.cols + j] = (int) image.at<Vec3b>(i,j)[0];
            (*g)[i*image.cols + j] = (int) image.at<Vec3b>(i,j)[1];
            (*r)[i*image.cols + j] = (int) image.at<Vec3b>(i,j)[2];
        }
    }

    printf("Read %s done.\n", filename);
    printf("******************************************\n");
    return 0;
}

void relu(int *r, int *g, int *b, int image_size)
{
    for(int i = 0; i < image_size; i++)
    {
        r[i] = std::max(r[i], 0);
        g[i] = std::max(g[i], 0);
        b[i] = std::max(b[i], 0);
    }

    return;
}

/*--------------------------------------------------------------------------------------
    Default will call relu function before display the image. To not use relu,
    assign use_relu = NO_RELU (NO_RELU is define in image.h)
----------------------------------------------------------------------------------------*/
void show_image(int *r, int *g, int *b, int width, int height, int use_relu)
{
    if(use_relu)
        relu(r, g, b, width * height);

    cv::Mat result_image(height, width, CV_8UC3, cv::Scalar(0, 0, 0));

    for(int i = 0; i < height; i++) {
        for(int j = 0; j < width; j++) {
            result_image.at<cv::Vec3b>(i, j)[0] = b[i*width + j];
            result_image.at<cv::Vec3b>(i, j)[1] = g[i*width + j];
            result_image.at<cv::Vec3b>(i, j)[2] = r[i*width + j];
        }
    }

    // Display the result image
    cv::namedWindow("view",CV_WINDOW_NORMAL);
    cv::resizeWindow("view", 1280, 720);
    cv::imshow("view", result_image);
    cv::waitKey(0);
    cv::destroyAllWindows();
    return;
}

void free_image(int *r, int *g, int *b)
{
    delete [] r;
    delete [] g;
    delete [] b;
    return;
}
