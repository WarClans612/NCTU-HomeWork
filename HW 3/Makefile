inte_size = 123456789
prim_size = 12345678
proc = 3
count = 10
all:
	mpicc integrate_mpi.c -o integrate -lm
	mpicc prime_mpi.c -o prime -lm
	time for i in {1..$(count)}; do (mpiexec -n 1 -hostfile hostfile1 ./integrate $(inte_size)); done > result
	time for i in {1..$(count)}; do (mpiexec -n 2 -hostfile hostfile2 ./integrate $(inte_size)); done >> result
	time for i in {1..$(count)}; do (mpiexec -n 3 -hostfile hostfile3 ./integrate $(inte_size)); done >> result
	time for i in {1..$(count)}; do (mpiexec -n 1 -hostfile hostfile1 ./prime $(prim_size)); done >> result
	time for i in {1..$(count)}; do (mpiexec -n 2 -hostfile hostfile2 ./prime $(prim_size)); done >> result
	time for i in {1..$(count)}; do (mpiexec -n 3 -hostfile hostfile3 ./prime $(prim_size)); done >> result
