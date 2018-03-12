#include <cstdlib>

#include <vector>
#include <iostream>
#include <algorithm>

#include "algo_hw1.hpp"

#define USE_GOOGLE_TEST
#if defined(USE_GOOGLE_TEST)
#include <gtest/gtest.h>
#endif

TEST(AlgoHW1, heapify) {
	int input[7] = { 7, 14, 6, 5, 1, 3, 8 };
	std::vector<int> expected = { 7, 14, 3, 5, 1, 6, 8 };
	min_heapify(input, sizeof(input) / sizeof(int), 2);

	std::vector<int> output;
	for (auto i = 0; i < sizeof(input) / sizeof(int); ++i) {
		output.push_back(input[i]);
	}

	EXPECT_TRUE(std::equal(expected.begin(), expected.end(), output.begin()));
}


TEST(AlgoHW1, build) {
	int input[7] = { 7, 14, 6, 5, 1, 3, 8 };
	min_heap_build(input, sizeof(input) / sizeof(int));
	std::vector<int> expected{ 1, 5, 3, 7, 14, 6, 8 };

	std::vector<int> output;
	for (auto i = 0; i < sizeof(input) / sizeof(int); ++i) {
		output.push_back(input[i]);
	}

	EXPECT_TRUE(std::equal(expected.begin(), expected.end(), output.begin()));
}

TEST(AlgoHW1, insert) {
	int input[8] = { 1, 5, 3, 7, 14, 6, 8 ,999 };
	min_heap_insert(input, sizeof(input) / sizeof(int), 4);
	std::vector<int> check{ 1, 4, 3, 5, 14, 6, 8 ,7 };

	std::vector<int> output;
	for (auto i = 0; i < sizeof(input) / sizeof(int); ++i) {
		output.push_back(input[i]);
	}

	EXPECT_TRUE(std::equal(check.begin(), check.end(), output.begin()));
}

TEST(AlgoHW1, minum) {
	int input[8] = { 1, 4, 3, 5, 14, 6, 8 ,7 };
	int expected;
	min_heap_minimum(input, sizeof(input) / sizeof(int), &expected);

	EXPECT_TRUE(expected == 1);	
}


TEST(AlgoHW1, extract) {
	int input[8] = { 1, 4, 3, 5, 14, 6, 8 ,7 };

	int expected_out;
	min_heap_extract(input, sizeof(input) / sizeof(int), &expected_out);
	std::vector<int> expected{ 3, 4, 6, 5, 14, 7, 8, 999};

	std::vector<int> output;
	for (auto i = 0; i < sizeof(input) / sizeof(int); ++i) {
		output.push_back(input[i]);
	}
	EXPECT_TRUE(expected_out == 1);
	EXPECT_TRUE(std::equal(expected.begin(), expected.end(), output.begin()));
}

TEST(AlgoHW1, sort) {
	int input[8] = { 1, 4, 3, 5, 14, 6, 8 ,7 };
	min_heap_sort(input, sizeof(input) / sizeof(int));
	std::vector<int> check{ 1, 3, 4, 5, 6, 7, 8, 14 };

	std::vector<int> output;
	for (auto i = 0; i < sizeof(input) / sizeof(int); ++i) {
		output.push_back(input[i]);
	}

	EXPECT_TRUE(std::equal(check.begin(), check.end(), output.begin()));
}


TEST(AlgoHW1, decrease) {
	int input[8] = { 1, 4, 3, 5, 14, 6, 8 ,7 };
	min_heap_decrease_key(input, sizeof(input) / sizeof(int), 3, 5);
	std::vector<int> check{ 0, 1, 3, 4, 14, 6, 8, 7 };

	std::vector<int> output;
	for (auto i = 0; i < sizeof(input) / sizeof(int); ++i) {
		output.push_back(input[i]);
	}

	EXPECT_TRUE(std::equal(check.begin(), check.end(), output.begin()));
}

int main(int argc, char **argv) {

	std::cout << student_id << "'s homework \n";

#if defined(USE_GOOGLE_TEST)
	::testing::InitGoogleTest(&argc, argv);
	auto res = RUN_ALL_TESTS();
#endif

	std::cout << "\nstudent_id is " << student_id << "\n";

	system("pause");

}


