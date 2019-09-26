#ifndef __FILTER_H__
#define __FILTER_H__

void load_filter(const char *filename, int *num_filters, int ***filter_mat, int **filter_size);
void print_filter(int *filter_mat, int filter_size);
void free_filter(int num_filters, int **filter_mat, int *filter_size);

#endif
