__kernel void histogram(
__global unsigned int *image_data,
__global unsigned int *ref_histogram_results,
unsigned int bound,
unsigned int eachsize)
{
    int col = get_global_id(0);
    unsigned int i, j;
    unsigned int index;
    size_t width = get_global_size(0);
    if(col<256*3) {
        ref_histogram_results[col] = 0;
    }
    for (i = 0; i < eachsize; i++) {
        if (col+(i*width) < bound) {
            for (j = 0; j < 3; j++) {
                index = image_data[(col+(i*width))*3+j];
                atomic_inc(ref_histogram_results+(index+j*256));
            }
        }
    }
 }