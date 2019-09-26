#ifndef __IMAGE_H__
#define __IMAGE_H__

#define NO_RELU  0
#define USE_RELU 1

int read_image(char *filename, int **r, int **g, int **b, int *width, int *height);
void relu(int *r, int *g, int *b, int image_size);
void show_image(int *r, int *g, int *b, int width, int height, int use_relu = USE_RELU);
void free_image(int *r, int *g, int *b);

#endif
