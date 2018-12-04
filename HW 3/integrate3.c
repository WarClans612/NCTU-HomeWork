//https://github.com/nctu-homeworks/PP-hw3/blob/master/s2/integrate.c
#include <mpi.h>
#include <stdio.h>
#include <math.h>

#define PI 3.1415926535

int main(int argc, char **argv) 
{
    MPI_Init(&argc, &argv);

    int size, rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

  long long i, num_intervals;
  double rect_width, area, sum, x_middle; 

    if(rank == 0)
      sscanf(argv[1], "%llu", &num_intervals);
    MPI_Bcast(&num_intervals, 1, MPI_LONG_LONG_INT, 0, MPI_COMM_WORLD);

  rect_width = PI / num_intervals;
    long long sub_interval = num_intervals / size;
    long long start = sub_interval * rank;
    long long end = start + sub_interval;

  sum = 0;
  for(i = start + 1; i < end + 1; i++) {

    /* find the middle of the interval on the X-axis. */ 

    x_middle = (i - 0.5) * rect_width;
    area = sin(x_middle) * rect_width; 
    sum += area;
  } 

    if(rank == 0)
        for(i = sub_interval * size + 1; i < num_intervals + 1; i++) {
            x_middle = (i - 0.5) * rect_width;
            area = sin(x_middle) * rect_width; 
            sum += area;
        }

    double final_sum;
    MPI_Reduce(&sum, &final_sum, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);

    if(rank == 0)
      printf("The total area is: %f\n", (float)final_sum);

    MPI_Finalize();
  return 0;
} 