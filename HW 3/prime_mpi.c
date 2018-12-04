#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "mpi.h"

int isprime(int n) {
    int i, square_root = (int) sqrt(n);
    for (i = 3; i <= square_root; i += 2)
        if (n % i == 0)
            return 0;
    return 1;
}

int main(int argc, char *argv[])
{
    int pc,       /* prime counter */
        foundone; /* most recent prime found */
    int pc_par = 0, foundone_par = 0;
    long long int n, limit;
    long long int start, end, part;
    int rank, size;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (rank == 0) {
        sscanf(argv[1],"%llu",&limit);    
        printf("Starting. Numbers to be scanned= %lld\n",limit);
    }

    MPI_Bcast(&limit, 1, MPI_LONG_LONG, 0, MPI_COMM_WORLD);

    part = (limit - 11) / size;
    start = 11 + rank * part; /* Assume (2,3,5,7) are counted here */
    end = (rank != size - 1) ? (start + part) : limit;
    start = (start % 2) ? start : (start + 1);


    for (n = start; n < end; n += 2) {
        if (isprime(n)) {
            ++pc_par;
            foundone_par = n;
        }
    }
    if ((rank == 0) && (limit % 2)) {
        if (isprime(limit)) {
            ++pc_par;
            foundone_par = limit;
        }
    }

    MPI_Reduce(&pc_par, &pc, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);
    MPI_Reduce(&foundone_par, &foundone, 1, MPI_INT, MPI_MAX, 0, MPI_COMM_WORLD);
    
    if (rank == 0) {
        printf("Done. Largest prime is %d Total primes %d\n",foundone,pc+4);
    }
    MPI_Finalize();
    return 0;
} 

