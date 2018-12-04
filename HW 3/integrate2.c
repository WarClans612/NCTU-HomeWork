//https://github.com/Jordan0605/MPI/blob/master/HW3_0556562/integrate.cpp
#include <stdio.h>
#include <math.h>
#include "mpi.h"

#define PI 3.1415926535

int main(int argc, char *argv[]) {
  int rank, size;
  MPI_Status status;
  MPI_Init(&argc, &argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  MPI_Comm_size(MPI_COMM_WORLD, &size);
  long long i, num_intervals;
  double rect_width, area, sum, x_middle;

  sscanf(argv[1], "%llu", &num_intervals);

  rect_width = PI / num_intervals;
  sum = 0;
  int quata = num_intervals/size;

  for(i=1+quata*rank ; i<1+quata*(rank+1)+1 ; i++){
    x_middle = (i-0.5) * rect_width;
    area = sin(x_middle) * rect_width;
    sum += area;
  }
  if(rank == size-1){
    for(i=1+quata*(rank+1)+1 ; i<num_intervals+1 ; i++){
      x_middle = (i-0.5) * rect_width;
      area = sin(x_middle) * rect_width;
      sum += area;
    }
  }
  if(rank != 0){
    MPI_Send(&sum, 1, MPI_DOUBLE, 0, 7777, MPI_COMM_WORLD);
  }

  MPI_Barrier(MPI_COMM_WORLD);

  if(rank == 0){
    double tmp;
    for(i=1 ; i<size ; i++){
      MPI_Recv(&tmp, 1, MPI_DOUBLE, i, 7777, MPI_COMM_WORLD, &status);
      sum += tmp;
    }
    printf("The total area is: %f\n", (float)sum);
  }

  MPI_Finalize();
  return 0;
}