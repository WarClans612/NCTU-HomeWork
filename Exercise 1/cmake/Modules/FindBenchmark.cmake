

if(WIN32)
    find_path(Benchmark_ROOT NAMES include/benchmark/benchmark.h HINTS
        "$ENV{BENCHMARK_ROOT}"
        "$ENV{BENCHMARK_SDK_ROOT}"
        "$ENV{BENCHMARK_DIR}"
    )
    message("Benchmark_ROOT is ${Benchmark_ROOT}")
elseif(UNIX)
else()
endif()

find_path(Benchmark_INCLUDE_DIRS NAMES benchmark/benchmark.h HINTS "${Benchmark_ROOT}/include/")

set( Benchmark_LIBNAME benchmark)
if(WIN32)
	find_library(Benchmark_LIBS "${Benchmark_LIBNAME}" HINTS ${Benchmark_ROOT}/lib)

endif()

message("Benchmark_LIBS are ${Benchmark_LIBS}")

if(Benchmark_INCLUDE_DIRS AND Benchmark_LIBS)
	set(Benchmark_FOUND 1)
endif() 
