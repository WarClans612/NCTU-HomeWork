#include <cstdio>
#include <cstdlib>
#include <vector>
#include <iostream>
#include <algorithm>
#include <cassert>
#include "algo_hw1.hpp"
using namespace std;

int main() {


//---------------------------------test1---------------------------------//
cout<<"test1:\n";
	int input1[7] = { 7, 14, 6, 5, 1, 3, 8 };
	int e1[7] = { 7, 14, 3, 5, 1, 6, 8 };
	
	cout<<"before: ";
	for (int i = 0; i < sizeof(input1) / sizeof(int); ++i) 
		cout<<input1[i]<<" ";
	
	
	min_heapify(input1, sizeof(input1) / sizeof(int), 2);

	cout<<"\n after: ";
	for (int i = 0; i < sizeof(input1) / sizeof(int); ++i) 
		cout<<input1[i]<<" ";
	
	cout<<"\nanswer: ";
	for (int i = 0; i < sizeof(input1) / sizeof(int); ++i) {
		cout<<e1[i]<<" ";
	}
//---------------------------------test1---------------------------------//



//---------------------------------test2---------------------------------//
	cout<<"\n\ntest2:\n";
	
	int input2[7] = { 7, 14, 6, 5, 1, 3, 8 };
	int e2[7] = { 1, 5, 3, 7, 14, 6, 8 };
	
	cout<<"before: ";
	for (int i = 0; i < sizeof(input2) / sizeof(int); ++i) 
		cout<<input2[i]<<" ";
	
	
	min_heap_build(input2, sizeof(input2) / sizeof(int));

	cout<<"\n after: ";
	for (int i = 0; i < sizeof(input2) / sizeof(int); ++i) 
		cout<<input2[i]<<" ";
	
	cout<<"\nanswer: ";
	for (int i = 0; i < sizeof(input2) / sizeof(int); ++i) {
		cout<<e2[i]<<" ";
	}
//---------------------------------test2---------------------------------//


//---------------------------------test3---------------------------------//
	cout<<"\n\ntest3:\n";
	
	int input3[8] = { 1, 5, 3, 7, 14, 6, 8 ,999 };
	int e3[8] = { 1, 4, 3, 5, 14, 6, 8 ,7 };
	
	cout<<"before: ";
	for (int i = 0; i < sizeof(input3) / sizeof(int); ++i) 
		cout<<input3[i]<<" ";
	
	
	min_heap_insert(input3, sizeof(input3) / sizeof(int), 4);

	cout<<"\n after: ";
	for (int i = 0; i < sizeof(input3) / sizeof(int); ++i) 
		cout<<input3[i]<<" ";
	
	cout<<"\nanswer: ";
	for (int i = 0; i < sizeof(input3) / sizeof(int); ++i) {
		cout<<e3[i]<<" ";
	}
//---------------------------------test3---------------------------------//


//---------------------------------test4---------------------------------//
	cout<<"\n\ntest4:\n";
	
	int input4[8] = { 1, 4, 3, 5, 14, 6, 8 ,7 };
	int expected;
	
	min_heap_minimum(input4, sizeof(input4) / sizeof(int), &expected);

	assert(expected==1);
	cout<<"expected = "<<expected<<endl;
//---------------------------------test4---------------------------------//


//---------------------------------test5---------------------------------//
	cout<<"\n\ntest5:\n";
	
	int input5[8] = { 1, 4, 3, 5, 14, 6, 8 ,7 };
	int expected_out;
	int e5[8] = { 3, 4, 6, 5, 14, 7, 8, 999};
	
	cout<<"before: ";
	for (int i = 0; i < sizeof(input5) / sizeof(int); ++i) 
		cout<<input5[i]<<" ";
	
	min_heap_extract(input5, sizeof(input5) / sizeof(int), &expected_out);
	assert(expected_out==1);
	cout<<"\nexpected_out = "<<expected_out<<endl;
	
	cout<<"\n after: ";
	for (int i = 0; i < sizeof(input5) / sizeof(int); ++i) 
		cout<<input5[i]<<" ";
	
	cout<<"\nanswer: ";
	for (int i = 0; i < sizeof(input5) / sizeof(int); ++i) {
		cout<<e5[i]<<" ";
	}
//---------------------------------test5---------------------------------//



//---------------------------------test6---------------------------------//
	cout<<"\n\ntest6:\n";
	
	int input6[8] = { 1, 4, 3, 5, 14, 6, 8 ,7 };
	int e6[8] = { 1, 3, 4, 5, 6, 7, 8, 14 };

	
	cout<<"before: ";
	for (int i = 0; i < sizeof(input6) / sizeof(int); ++i) 
		cout<<input6[i]<<" ";
	
	min_heap_sort(input6, sizeof(input6) / sizeof(int));
	
	cout<<"\n after: ";
	for (int i = 0; i < sizeof(input6) / sizeof(int); ++i) 
		cout<<input6[i]<<" ";
	
	cout<<"\nanswer: ";
	for (int i = 0; i < sizeof(input6) / sizeof(int); ++i) {
		cout<<e6[i]<<" ";
	}
//---------------------------------test6---------------------------------//


//---------------------------------test7---------------------------------//
	cout<<"\n\ntest7:\n";
	
	int input7[8] = { 1, 4, 3, 5, 14, 6, 8 ,7 };
	int e7[8] = { 0, 1, 3, 4, 14, 6, 8, 7 };

	
	cout<<"before: ";
	for (int i = 0; i < sizeof(input7) / sizeof(int); ++i) 
		cout<<input7[i]<<" ";
	
	min_heap_decrease_key(input7, sizeof(input7) / sizeof(int), 3, 5);
	
	cout<<"\n after: ";
	for (int i = 0; i < sizeof(input7) / sizeof(int); ++i) 
		cout<<input7[i]<<" ";
	
	cout<<"\nanswer: ";
	for (int i = 0; i < sizeof(input7) / sizeof(int); ++i) {
		cout<<e7[i]<<" ";
	}
//---------------------------------test7---------------------------------//

	return 0;
}
