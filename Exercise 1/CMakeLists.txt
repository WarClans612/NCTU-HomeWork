cmake_minimum_required(VERSION 3.5)
# C++14 is required
set(CMAKE_CXX_STANDARD 14)

set(PRROJ_NAME "algo_hw1")
project (${PRROJ_NAME})

# user define Find_packages
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/Modules)

include_directories("${CMAKE_SOURCE_DIR}/include")

set(PROJ_INCLUDE_DIRS ${PROJ_INCLUDE_DIRS} "${PROJECT_SOURCE_DIR}/include")
file(GLOB_RECURSE My_LIB_SOURCES "${CMAKE_SOURCE_DIR}/src/*.cpp")
file(GLOB_RECURSE My_HEADERS "${CMAKE_SOURCE_DIR}/include/*.hpp")
file(GLOB_RECURSE My_HEADERS "${CMAKE_SOURCE_DIR}/*.hpp")
set(HEADERS ${HEADERS} ${My_HEADERS}) 
set(SOURCES ${SOURCES} main.cpp ${HEADERS}) 
set(LIB_SOURCES ${LIB_SOURCES})
add_executable(${PRROJ_NAME} ${SOURCES})

include(${CMAKE_SOURCE_DIR}/cmake/getGTest.cmake)
#include(${CMAKE_SOURCE_DIR}/cmake/getBenchmark.cmake)


message("include_directories(${PROJ_INCLUDE_DIRS})")
include_directories(${PROJ_INCLUDE_DIRS})

message("target_link_libraries(${PRROJ_NAME} ${PROJ_LIBRARIES})")
target_link_libraries(${PRROJ_NAME} ${PROJ_LIBRARIES})

set(MY_CPP_FLAGS ${MY_CPP_FLAGS})
if(UNIX)
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O3")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${MY_CPP_FLAGS} -I/usr/local/include -Wall")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -L/usr/local/lib") 
endif()
