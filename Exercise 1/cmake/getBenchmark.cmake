
# finding google Benchmark

set(PACKAGE_TARGET Benchmark)
find_package(${PACKAGE_TARGET})
message("${PACKAGE_TARGET}_FOUND is ${${PACKAGE_TARGET}_FOUND}") 
if(${${PACKAGE_TARGET}_FOUND})
    set(PROJ_INCLUDE_DIRS ${PROJ_INCLUDE_DIRS} "${${PACKAGE_TARGET}_INCLUDE_DIRS}")
    set(PROJ_LIBRARIES ${PROJ_LIBRARIES} "${${PACKAGE_TARGET}_LIBS}")
endif() 