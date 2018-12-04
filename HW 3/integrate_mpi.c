#include <stdio.h>
#include <math.h>
#include "mpi.h"

#define PI 3.1415926535

int main(int argc, char **argv) 
{
    long long i, num_intervals;
    long long start, end, part;
    double rect_width, sum, x_middle, sum_par = 0;
    int rank, size;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (rank == 0) {
        sscanf(argv[1],"%llu",&num_intervals);
    }

    MPI_Bcast(&num_intervals, 1, MPI_LONG_LONG, 0, MPI_COMM_WORLD);

    part = (num_intervals - 1) / size;
    start = 1 + rank * part;
    end = (rank != size - 1) ? (start + part) : num_intervals;
    rect_width = PI / num_intervals;

    for(i = start; i < end + 1; ++i) {

        /* find the middle of the interval on the X-axis. */ 

        x_middle = (i - 0.5) * rect_width;
        sum_par += sin(x_middle);
    }
    if (rank == 0) {
        x_middle = (num_intervals - 0.5) * rect_width;
        sum_par += sin(x_middle);
    }
    MPI_Reduce(&sum_par, &sum, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);

    if (rank == 0) {
        printf("The total area is: %f\n", (float)(sum * rect_width));
    }
    MPI_Finalize();
    return 0;
}   

