//https://github.com/nctu-homeworks/PP-hw3/blob/master/s1/prime.c
#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int isprime(long long int n) {
    long long int i, squareroot;

    squareroot = (long long int) sqrt(n);

    for (i=3; i<=squareroot; i+=2)
        if ((n % i) == 0)
            return 0;
    return 1;
}

int main(int argc, char *argv[])
{
    MPI_Init(&argc, &argv);

    int size, rank;
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    long long int limit;
    long long int look_size;

    if(rank == 0) {
        sscanf(argv[1], "%llu", &limit);    
        printf("Starting. Numbers to be scanned= %lld\n", limit);

        look_size = limit / size;
    }
    MPI_Bcast(&look_size, 1, MPI_LONG_LONG_INT, 0, MPI_COMM_WORLD);

    int pc = 0; // prime counter
    long long int foundone = 0;
    long long int start_from = look_size * rank;
    long long int end_at = start_from + look_size;

    if(start_from < 11)
        start_from = 11;
    if(start_from % 2 == 0)
        start_from++;

    for (; start_from<end_at; start_from+=2) {
        if (isprime(start_from)) {
            pc++;
            foundone = start_from;
        }           
    }

    if(rank == 0) {
        start_from=look_size*size;
        if(start_from % 2 == 0)
            start_from++;

        for(; start_from<=limit; start_from+=2) {
            if(isprime(start_from)) {
                pc++;
                foundone = start_from;
            }
        }

        pc += 4; // Assume (2,3,5,7) are counted here
    }

    int final_pc;
    long long int final_max;
    MPI_Reduce(&pc, &final_pc, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);
    MPI_Reduce(&foundone, &final_max, 1, MPI_LONG_LONG_INT, MPI_MAX, 0, MPI_COMM_WORLD);

    if(rank == 0)
        printf("Done. Largest prime is %lld Total primes %d\n", final_max, final_pc);

    MPI_Finalize();
    return 0;
}