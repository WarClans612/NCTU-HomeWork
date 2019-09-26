cmake_minimum_required(VERSION 2.8)
project( ParallelConvolutionLayer )

find_package( OpenCV REQUIRED )
include_directories( ${OpenCV_INCLUDE_DIRS} )

find_package(CUDA REQUIRED)
include_directories(${CUDA_INCLUDE_DIRS})

set(CMAKE_CXX_STANDARD 11)
#set(CUDA_NVCC_FLAGS -D_FORCE_INLINES)

cuda_add_executable( cuda_m convolution.cu image.cpp filter.cpp )
target_link_libraries( cuda_m ${OpenCV_LIBS} )

# add_executable( thread_m thread_matrix.cpp image.cpp filter.cpp )
# target_compile_options( thread_m PUBLIC "-pthread")
# target_link_libraries( thread_m ${OpenCV_LIBS} )




