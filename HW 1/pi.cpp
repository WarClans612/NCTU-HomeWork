#include<cstdio>
#include<pthread.h>
#include<random>
#include<climits>

#define MIN_RANDOM  INT_MIN
#define MAX_RANDOM  INT_MAX

static std::random_device rd;
static std::mt19937 rng(rd());
static std::uniform_int_distribution<int> uid(MIN_RANDOM,MAX_RANDOM);
static long long int toss_num;
static long long int *hit_num;
static int cpu_num;

/*
    Paralel function to calculate pi estimation
*/
void* paralel_pi_estimate(void* pi_in_obj) {
    int random_seed = uid(rng);
    int hit_index = *(int*)pi_in_obj;
    long long int toss_index = toss_num/cpu_num;
    long long int temp_hit_num = 0;
    for(long long int i = 0; i < toss_index; ++i) {
        random_seed = (214013*random_seed+2531011);
        double x = (double)random_seed/MAX_RANDOM;
        random_seed = (214013*random_seed+2531011);
        double y = (double)random_seed/MAX_RANDOM;

        if(x*x + y*y <= 1) {
            ++temp_hit_num;
        }
    }
    *(hit_num + hit_index) = temp_hit_num;
    pthread_exit(NULL);
}

int main(int argc, char** argv) {
    /*
        Managing program arguments
        Accepting two command-line arguments,
        which indicate the number of CPU cores and the number of tosses
    */
    cpu_num = atoi(argv[1]);
    toss_num = atoll(argv[2]);

    /*
        Allocationg needed data for the paralel parts
    */
    hit_num = (long long int*)malloc(cpu_num*sizeof(long long int));
    pthread_t *pi_paralel = (pthread_t*)malloc(cpu_num*sizeof(pthread_t));
    int *pi_input_args = (int*)malloc(cpu_num*sizeof(int));
    for(int i = 0; i < cpu_num-1; ++i) {
        *(pi_input_args+i) = i;
        pthread_create(pi_paralel+i, NULL, paralel_pi_estimate, (void*)(pi_input_args+i));
    }

    /*
        Main thread calculate the rest
    */
    int random_seed = uid(rng);
    int hit_index = cpu_num-1;
    long long int toss_index = toss_num - (toss_num/cpu_num*(cpu_num-1));
    long long int temp_hit_num = 0;
    for(long long int i = 0; i < toss_index; ++i) {
        random_seed = (214013*random_seed+2531011);
        double x = (double)random_seed/MAX_RANDOM;
        random_seed = (214013*random_seed+2531011);
        double y = (double)random_seed/MAX_RANDOM;

        if(x*x + y*y <= 1) {
            ++temp_hit_num;
        }
    }
    *(hit_num + hit_index) = temp_hit_num;


    /*
        Waiting all thread to join
    */
    for(int i = 0; i < cpu_num-1; ++i) {
        pthread_join(*(pi_paralel+i), NULL);
    }

    /*
        Calculating the sum for number of result
    */
    long long int hit_sum = 0;
    for(int i = 0; i < cpu_num; ++i) {
        hit_sum += *(hit_num+i);
    }
    double pi_estimate = 4*hit_sum/(double)toss_num;
    printf("%lf\n", pi_estimate);

    /*
        Deallocation data
    */
    free(hit_num);
    free(pi_paralel);
    free(pi_input_args);

    return 0;
}