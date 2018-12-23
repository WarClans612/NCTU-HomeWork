count = 10
int1 = 12345
int2 = 54321
all:
	nvcc cuda_wave.cu -o cuda_wave
	./cuda_wave $(int1) $(int2) > cuda_answer
	gcc serial_wave.c -o serial_wave -lm
	./serial_wave $(int1) $(int2) > serial_answer