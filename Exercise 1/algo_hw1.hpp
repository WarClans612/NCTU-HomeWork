static const char* student_id = "0416106" ;

//Function to retrieve parent
int parent(int i)
{
    return (i-1) / 2;
}

//Function to retrieve left subtree
int left(int i)
{
    return 2*i + 1;
}

//Function to retrieve right subtree
int right(int i)
{
    return 2*i + 2;
}

void swaps(int *a, int *b)
{
    int temp;
    temp = *a;
    *a = *b;
    *b = temp;
}

void min_heapify(int * input_array, int size, int position) {
	// I'll give you an array without ordered
	// please write an algorithm as text book
	//
	// Example:
	//      input : { 7, 14, 6, 5, 1, 3, 8 } ,7, 2
	//   expected : { 7, 14, 3, 5, 1, 6, 8 }
    int smallest;
    //Maintaining position to start from 1 instead of 0 in the input array
    int l = left(position);
    int r = right(position);
    if(l < size && input_array[l] < input_array[position])
        smallest = l;
    else
        smallest = position;
    if(r < size && input_array[r] < input_array[smallest])
        smallest = r;
    if(smallest != position) {
        //Exchange input_array[i] and input_array[smallest]
        swaps(input_array+position, input_array+smallest);
        //Recursive call
        min_heapify(input_array, size, smallest);
    }
}

void min_heap_build(int * input_array, int size) {
	// I'll give you an array without ordered
	// please make this whole array as a min-heap tree
	//
	// Example:
	//      input : { 7, 14, 6, 5, 1, 3, 8 } ,7
	//   expected : { 1, 5, 3, 7, 14, 6, 8 }
    for(int i = size / 2; i >= 0; --i)
        min_heapify(input_array, size, i);
}

//Function to bubble up the key by given position
void bubble_up(int * input_heap, int size, int position)
{
    for(int i = position; i > 0 && input_heap[parent(i)] > input_heap[i]; i = parent(i))
    {
        swaps(input_heap+i, input_heap+parent(i));
    }
}

void min_heap_insert(int * input_heap, int size, int key) {
	// I'll give you an array which is a min heap has one more space
	// (finally value 999 is not a true value)
	// please change the 999 into key
	// and make this array as a min-heap tree
	//
	// Example:
	//      input : { 1, 5, 3, 7, 14, 6, 8, 999 }, 8, 4
	//   expected : { 1, 4, 3, 5, 14, 6, 8 ,7}
    input_heap[size-1] = key;
    bubble_up(input_heap, size, size-1);
}

void min_heap_minimum(int * input_heap, int size, int * output_key) {
	// I'll give you an array which is a min heap
	// please show the smallest value
	//
	// Example:
	//      input : { 1, 4, 3, 5, 14, 6, 8 ,7} , 8, &output_key
	//   expected : output_key == 1
    *output_key = input_heap[0];
}

void min_heap_extract(int * input_heap, int size, int * output_key) {
	// I'll give you an array which is a min heap
	// please tell me which is the smallest value
	// after delete(swap) that value , adjust array as heap
	// finall, make the final value 999 as fake
	//
	// Example:
	//      input : { 1, 4, 3, 5, 14, 6, 8 ,7} , 8, &output_key
	//   expected : { 3, 4, 6, 5, 14, 7, 8, 999} ,output_key == 1
    min_heap_minimum(input_heap, size, output_key);
    input_heap[0] = input_heap[size-1];
    input_heap[size-1] = 999;
    min_heapify(input_heap, --size, 0);
}

void reverses(int* input_array, int size)
{
    for(int i = 0; i < size/2; ++i)
    {
        swaps(input_array+i, input_array+size-i-1);
    }
}

void sorting(int* input_heap, int size)
{
    min_heap_build(input_heap, size);
    for(int i = size - 1; i > 0; --i) {
        //Exchange input_array[i] and input_array[smallest]
        swaps(input_heap, input_heap+i);
        min_heapify(input_heap, --size, 0);
    }
}

void min_heap_sort(int* input_heap, int size) {
	//
	// you cannot use library sort function!
	//
	// I'll give you an array which is a min heap
	// please sort it
	//
	// Example:
	//      input : { 1, 4, 3, 5, 14, 6, 8 ,7} ,8
	//   expected : { 1, 3, 4, 5, 6, 7, 8, 14}
    sorting(input_heap, size);
    //Result from mi heap sorting is descending so need to be reversed
    reverses(input_heap, size);
}


void min_heap_decrease_key(int * input_heap, int size, int position, int decrease) {
	// I'll give you an array which is a min heap
	// the position need to be decreased by a value(ex: 5 - 5 = 0)
	// please adjust the result as a min-heap
	//
	// Example:
	//      input : { 1, 4, 3, 5, 14, 6, 8, 7}, 8, 3, 5
	//   expected : { 0, 1, 3, 4, 14, 6, 8, 7}
    input_heap[position] -= decrease;
    bubble_up(input_heap, size, position);
}
