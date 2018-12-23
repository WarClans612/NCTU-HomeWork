#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <math.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <fstream>
#include <sstream>
#include <iostream>
#include <CL/cl.h>

using namespace std;

int main(int argc, char** argv)
{
    int err;                            // error code returned from api calls

    size_t global;                      // global domain size for our calculation
    size_t local;                       // local domain size for our calculation
    size_t max_work[3];
    size_t max_items;

    cl_device_id        device_id;      // compute device id 
    cl_context          context;        // compute context
    cl_command_queue    commands;       // compute command queue
    cl_program          program;        // compute program
    cl_kernel           kernel;         // compute kernel
    cl_platform_id      platform;

    cl_mem input;                       // device memory used for the input array
    cl_mem output;                      // device memory used for the output array
    
    unsigned int *histogram_results = new unsigned int[256*3];
    unsigned int i=0, a, input_size;
    unsigned int bound;
    unsigned int each_size;
    fstream inFile("input", ios_base::in);
    ofstream outFile("0416106.out", ios_base::out);

    fstream source("histogram.cl", ios_base::in);
    stringstream ss;
    string code_str;
    const char *KernelSource;
    ss << source.rdbuf();
    code_str = ss.str();
    KernelSource = code_str.c_str();
    
    memset(histogram_results, 0, sizeof(unsigned)*256*3);
    
    inFile >> input_size;
    bound = input_size/3;
    unsigned int *image = new unsigned int[input_size];
    while( inFile >> a ) {
        image[i++] = a;
    }
   
    err = clGetPlatformIDs(1, &platform, NULL); 
    if (err != CL_SUCCESS) {
        printf("Error: Failed to get Platform ID!\n");
        printf("%d",err);
        return EXIT_FAILURE;
    }
   
    // Connect to a compute device
    //
    err = clGetDeviceIDs(platform, CL_DEVICE_TYPE_GPU, 1, &device_id, NULL);
    if (err != CL_SUCCESS) {
        printf("Error: Failed to create a device group!\n");
        printf("%d",err);
        return EXIT_FAILURE;
    }

    err = clGetDeviceInfo(device_id, CL_DEVICE_MAX_WORK_ITEM_SIZES, sizeof(max_work), &max_work, NULL);
    if (err != CL_SUCCESS) {
        printf("Error: Failed to get device info!\n");
        printf("%d",err);
        return EXIT_FAILURE;
    }
    
    max_items = max_work[0]*max_work[1]*max_work[2];
    if(bound > max_items) { 
        each_size = bound / max_items;
        if(bound%max_items!=0) each_size++;
    }
    else { 
        each_size = 1;
    }
  
    // Create a compute context 
    //
    context = clCreateContext(0, 1, &device_id, NULL, NULL, &err);
    if (!context) {
        printf("Error: Failed to create a compute context!\n");
        return EXIT_FAILURE;
    }

    // Create a command commands
    //
    commands = clCreateCommandQueue(context, device_id, 0, &err);
    if (!commands) {
        printf("Error: Failed to create a command commands!\n");
        return EXIT_FAILURE;
    }

    // Create the compute program from the source buffer
    //
    program = clCreateProgramWithSource(context, 1, (const char **) & KernelSource, NULL, &err);
    if (!program) {
        printf("Error: Failed to create compute program!\n");
        return EXIT_FAILURE;
    }

    // Build the program executable
    //
    err = clBuildProgram(program, 0, NULL, NULL, NULL, NULL);
    if (err != CL_SUCCESS) {
        size_t len;
        char *buffer;
        clGetProgramBuildInfo(program, device_id, CL_PROGRAM_BUILD_LOG, 0, NULL, &len);
        buffer = new char[len];
        printf("Error: Failed to build program executable!\n");
        clGetProgramBuildInfo(program, device_id, CL_PROGRAM_BUILD_LOG, len, buffer, NULL);
        printf("%s\n", buffer);
        exit(1);
    }

    // Create the compute kernel in the program we wish to run
    //
    kernel = clCreateKernel(program, "histogram", &err);
    if (!kernel || err != CL_SUCCESS) {
        printf("Error: Failed to create compute kernel!\n");
        exit(1);
    }

    // Create the input and output arrays in device memory for our calculation
    //
    input = clCreateBuffer(context,  CL_MEM_READ_ONLY,  sizeof(unsigned) * input_size, NULL, NULL);
    output = clCreateBuffer(context, CL_MEM_WRITE_ONLY, sizeof(unsigned) * 256 * 3, NULL, NULL);
    if (!input || !output) {
        printf("Error: Failed to allocate device memory!\n");
        exit(1);
    }    
    
    // Write our data set into the input array in device memory 
    //
    err = clEnqueueWriteBuffer(commands, input, CL_TRUE, 0, sizeof(unsigned) * input_size, image, 0, NULL, NULL);
    if (err != CL_SUCCESS) {
        printf("Error: Failed to write to source array!\n");
        exit(1);
    }
    // Set the arguments to our compute kernel
    //
    err = 0;
    err  = clSetKernelArg(kernel, 0, sizeof(cl_mem), &input);
    err |= clSetKernelArg(kernel, 1, sizeof(cl_mem), &output);
    err |= clSetKernelArg(kernel, 2, sizeof(unsigned int), &bound);
    err |= clSetKernelArg(kernel, 3, sizeof(unsigned int), &each_size);
    if (err != CL_SUCCESS) {
        printf("Error: Failed to set kernel arguments! %d\n", err);
        exit(1);
    }

    // Get the maximum work group size for executing the kernel on the device
    //
    err = clGetKernelWorkGroupInfo(kernel, device_id, CL_KERNEL_WORK_GROUP_SIZE, sizeof(local), &local, NULL);
    if (err != CL_SUCCESS) {
        printf("Error: Failed to retrieve kernel work group info! %d\n", err);
        exit(1);
    }

    // Execute the kernel over the entire range of our 1d input data set
    // using the maximum number of work group items for this device
    //
    global = max_items;
    err = clEnqueueNDRangeKernel(commands, kernel, 1, NULL, &global, &local, 0, NULL, NULL);
    if (err) {
        printf("Error: Failed to execute kernel!\n");
        printf("%d",err);
        return EXIT_FAILURE;
    }

    // Wait for the command commands to get serviced before reading back results
    //
    clFinish(commands);

    // Read back the results from the device to verify the output
    //
    err = clEnqueueReadBuffer( commands, output, CL_TRUE, 0, sizeof(unsigned) * 256 * 3, histogram_results, 0, NULL, NULL );

    if (err != CL_SUCCESS) {
        printf("Error: Failed to read output array! %d\n", err);
        exit(1);
    }
    for(unsigned int i = 0; i < 256 * 3; ++i) {
        if (i % 256 == 0 && i != 0)
            outFile << endl;
        outFile << histogram_results[i]<< ' ';
    }
    
    delete [] histogram_results;
    delete [] image;
    inFile.close();
    outFile.close();
    
    // Shutdown and cleanup
    //
    clReleaseMemObject(input);
    clReleaseMemObject(output);
    clReleaseProgram(program);
    clReleaseKernel(kernel);
    clReleaseCommandQueue(commands);
    clReleaseContext(context);

    return 0;
}
