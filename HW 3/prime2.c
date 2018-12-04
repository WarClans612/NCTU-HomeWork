//https://github.com/Jordan0605/MPI/blob/master/HW3_0556562/prime.cpp
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "mpi.h"

int isprime(int n){
  int i, squareroot;
  if(n > 10){
    squareroot = (int) sqrt(n);
    for(i=3 ; i<=squareroot ; i=i+2)
      if((n%i) == 0) return 0;
    return 1;
  }
  else return 0;
}

int main(int argc, char *argv[]) {
  int rank, size;
  MPI_Status status;
  MPI_Init(&argc, &argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  MPI_Comm_size(MPI_COMM_WORLD, &size);

  int pc, foundone;
  long long int n, limit;

  sscanf(argv[1], "%llu", &limit);
  if(rank == 0)
    printf("Starting. Numbers to be scanned = %lld.\n", limit);

  pc = 0;

  int quata = (limit - 11)/size;
  int start;
  start = quata*rank;
  if(start%2 == 1) start++;

  for(n=11+start ; n<11+quata*(rank+1) ; n=n+2){
    if(isprime(n)){
      pc++;
      foundone = n;
    }
  }
  //處理多出來的
  if(rank == size-1){
    for(n=11+quata*(rank+1) ; n<=limit ; n=n+2){
      if(isprime(n)){
        pc++;
        foundone = n;
      }
    }
  }
  if(rank != 0){
    MPI_Send(&pc, 1, MPI_INT, 0, 1111, MPI_COMM_WORLD);
    MPI_Send(&foundone, 1, MPI_INT, 0, 1112, MPI_COMM_WORLD);
  }

  MPI_Barrier(MPI_COMM_WORLD);

  int total_pc = 4;
  int max_foundone;
  if(rank == 0){
    total_pc += pc;
    max_foundone = foundone;
    for(int j=1 ; j<size ; j++){
      MPI_Recv(&pc, 1, MPI_INT, j, 1111, MPI_COMM_WORLD, &status);
      total_pc += pc;
      MPI_Recv(&foundone, 1, MPI_INT, j, 1112, MPI_COMM_WORLD, &status);
      if(foundone > max_foundone) max_foundone = foundone;
    }
  }
  /*for(n=11 ; n<=limit ; n=n+2){
    if(isprime(n)){
      pc++;
      foundone = n;
    }
  }*/
  if(rank == 0)
    printf("Done. Largest prime is %d. Total primes %d.\n", max_foundone, total_pc);

  MPI_Finalize();
  return 0;
}