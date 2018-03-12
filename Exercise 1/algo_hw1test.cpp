#include <cstdlib>

#include <vector>
#include <iostream>
#include <algorithm>
#include "algo_hw1.hpp"


int main(int argc, char **argv) {	
	
	int score = 100;

	std::vector<int> input0{ 15, 77, 80, 111, 345, 6, 78, 24, 57, 33, 89, 11, 29, 33, 25, 67, 99, 100 };
	std::vector<int> expect0{ 15,77,80,24,345,6,78,67,57,33,89,11,29,33,25,111,99,100 };
	min_heapify(input0.data(), input0.size(), 3);
	std::cout << "min_heapify answer is " << std::equal(input0.begin(), input0.end(), expect0.begin()) << "\n";
	if (!std::equal(input0.begin(), input0.end(), expect0.begin())) score -= 15;

	std::vector<int> input1{ 15, 77, 80, 111, 345, 6, 78, 24, 57, 33, 89, 11, 29, 33, 25, 67, 99, 100 };
	std::vector<int> expect1{ 6,24,11,57,33,15,25,67,77,345,89,80,29,33,78,111,99,100 };
	min_heap_build(input1.data(), input1.size());
	std::cout << "min_heap_build answer is " << std::equal(input1.begin(), input1.end(), expect1.begin()) << "\n";
	if (!std::equal(input1.begin(), input1.end(), expect1.begin())) score -= 15;


	std::vector<int> input2{ 6,24,11,57,33,15,25,67,77,345,89,80,29,33,78,111,99,100, 999 };
	std::vector<int> expect2{ 6,24,11,55,33,15,25,67,57,345,89,80,29,33,78,111,99,100,77 };
	min_heap_insert(input2.data(), input2.size(), 55);
	std::cout << "min_heap_insert answer is " << std::equal(input2.begin(), input2.end(), expect2.begin()) << "\n";
	if (!std::equal(input2.begin(), input2.end(), expect2.begin())) score -= 15;

	int expected_out;
	std::vector<int> input3{ 6,24,11,57,33,15,25,67,77,345,89,80,29,33,78,111,99,100 };
	min_heap_minimum(input3.data(), input3.size(), &expected_out);
	std::cout << "min_heap_minimum answer is " << (expected_out == 6 )<< "\n";
	if (!expected_out == 6) score -= 15;

	std::vector<int> input4{ 6,24,11,57,33,15,25,67,77,345,89,80,29,33,78,111,99,100 };
	std::vector<int> expect4{ 11,24,15,57,33,29,25,67,77,345,89,80,100,33,78,111,99,999 };
	min_heap_extract(input4.data(), input4.size(), &expected_out);
	std::cout << "min_heap_minimum answer is " <<
		( (expected_out == 6) && std::equal(input4.begin(), input4.end(), expect4.begin()) )
		<< "\n";
	if (!(expected_out == 6) && std::equal(input4.begin(), input4.end(), expect4.begin())) score -= 15;

	std::vector<int> input5{ 6,24,11,57,33,15,25,67,77,345,89,80,29,33,78,111,99,100 };
	std::vector<int> expect5{ 6,11,15,24,25,29,33,33,57,67,77,78,80,89,99,100,111,345 };
	min_heap_sort(input5.data(), input5.size());
	std::cout << "min_heap_sort answer is " << std::equal(input5.begin(), input5.end(), expect5.begin()) << "\n";
	if (!std::equal(input5.begin(), input5.end(), expect5.begin() ) )score -= 15;

	std::vector<int> input6{ 6,24,11,57,33,15,25,67,77,345,89,80,29,33,78,111,99,100 };
	std::vector<int> expect6{ 6,24,11,57,33,15,14,67,77,345,89,80,29,33,78,111,99,100 };
	min_heap_decrease_key(input6.data(), input6.size(), 6, 11);
	std::cout << "min_heap_decrease_key answer is " << std::equal(input6.begin(), input6.end(), expect6.begin()) << "\n";
	if (!std::equal(input6.begin(), input6.end(), expect6.begin()))score -= 15;
	

	std::cout << "student " << student_id << " score may be " << score << "\n";

	system("pause");
}