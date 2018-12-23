/**********************************************************************
 * DESCRIPTION:
 *   Cuda Concurrent Wave Equation - Cuda Version
 *   This program implements the concurrent wave equation
 *********************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#define MAXPOINTS 1000000
#define MAXSTEPS 1000000
#define MINPOINTS 20
#define PI 3.14159265

void check_param(void);
__global__ void initLine(float*, float*, int);
__global__ void updateAll(float*, float*, int, int);
void printfinal (void);

int nsteps,                     /* number of time steps */
    tpoints,                    /* total points along string */
    rcode;                      /* generic return code */
int allocPoints;
float *currVal,                 /* values at time t */
    *devCurrVal,                /* values at time (t+dt) */
    *devPrevVal;                /* values at time (t-dt) */

static void handleError(cudaError_t err, const char *file, int line) {
    if (err != cudaSuccess) {
        printf("%s in %s at line %d\n", cudaGetErrorString(err), file, line);
        exit(EXIT_FAILURE);
    }
}
#define HANDLE_ERROR(err) (handleError(err, __FILE__, __LINE__))

/**********************************************************************
 *  Checks input values from parameters
 *********************************************************************/
void check_param(void)
{
   char tchar[20];

   /* check number of points, number of iterations */
   while ((tpoints < MINPOINTS) || (tpoints > MAXPOINTS)) {
      printf("Enter number of points along vibrating string [%d-%d]: "
           ,MINPOINTS, MAXPOINTS);
      scanf("%s", tchar);
      tpoints = atoi(tchar);
      if ((tpoints < MINPOINTS) || (tpoints > MAXPOINTS))
         printf("Invalid. Please enter value between %d and %d\n", 
                 MINPOINTS, MAXPOINTS);
   }
   while ((nsteps < 1) || (nsteps > MAXSTEPS)) {
      printf("Enter number of time steps [1-%d]: ", MAXSTEPS);
      scanf("%s", tchar);
      nsteps = atoi(tchar);
      if ((nsteps < 1) || (nsteps > MAXSTEPS))
         printf("Invalid. Please enter value between 1 and %d\n", MAXSTEPS);
   }

   printf("Using points = %d, steps = %d\n", tpoints, nsteps);

}

/**********************************************************************
 *     Initialize points on line
 *********************************************************************/
__global__ void initLine(float *__devPrevVal, float *__devCurrVal, int __tpoints) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < __tpoints) {
        float x = (float) i / (__tpoints - 1);
        __devPrevVal[i] = __devCurrVal[i] = __sinf(2.0 * PI * x);
    }
}

/**********************************************************************
 *     Update all values along line a specified number of times
 *********************************************************************/
__global__ void updateAll(float *__devPrevVal, float *__devCurrVal, int __tpoints, int __nsteps) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < __tpoints) {
        float locPrevVal = __devPrevVal[i], locCurrVal = __devCurrVal[i] , locNextVal;
        for (int j = 0; j < __nsteps; j++) {
            if ((i == 0) || (i == __tpoints - 1))
                locNextVal = 0.0;
            else
                locNextVal = 1.82 * locCurrVal - locPrevVal;
            locPrevVal = locCurrVal;
            locCurrVal = locNextVal;
        }
        __devCurrVal[i] = locCurrVal;
    }
}

/**********************************************************************
 *     Print final results
 *********************************************************************/
void printfinal()
{
   int i;

   for (i = 0; i < tpoints; i++) {
      printf("%6.4f ", currVal[i]);
      if ((i+1)%10 == 0)
         printf("\n");
   }
}

/**********************************************************************
 *  Main program
 *********************************************************************/
int main(int argc, char *argv[])
{
    sscanf(argv[1],"%d",&tpoints);
    sscanf(argv[2],"%d",&nsteps);
    check_param();

    allocPoints = tpoints + 256;
    currVal = (float*) malloc(allocPoints * sizeof(float));
    if (!currVal)
        exit(EXIT_FAILURE);
    HANDLE_ERROR(cudaMalloc((void**) &devCurrVal, allocPoints * sizeof(float)));
    HANDLE_ERROR(cudaMalloc((void**) &devPrevVal, allocPoints * sizeof(float)));
    dim3 threadsPerBlock(256);
    dim3 numOfBlocks(allocPoints/256);

    printf("Initializing points on the line...\n");
    initLine<<<numOfBlocks, threadsPerBlock>>>(devPrevVal, devCurrVal, tpoints);

    printf("Updating all points for all time steps...\n");
    updateAll<<<numOfBlocks, threadsPerBlock>>>(devPrevVal, devCurrVal, tpoints, nsteps);

    printf("Printing final results...\n");
    HANDLE_ERROR(cudaMemcpy(currVal, devCurrVal, allocPoints * sizeof(float), cudaMemcpyDeviceToHost));
    printfinal();
    printf("\nDone.\n\n");
    
    cudaFree(devCurrVal);
    cudaFree(devPrevVal);
    free(currVal);
    
    return 0;
}
