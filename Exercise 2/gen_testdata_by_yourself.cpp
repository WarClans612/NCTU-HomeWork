#include "algo_hw2.hpp"

#include <iostream>
#include <vector>
#include <array>
#include <tuple>

#include <cstddef>
#include <cstdlib>

enum class Judge{ basic = 2, advance = 3,};

int main(int argc, char **argv) {

	using test_node = std::array<int, 3>;
	test_node Empty{ -1, -1, -1 };
	test_node NIL{ 0, 0, 0 };
	std::vector<test_node> input_nodes(64, Empty);
	std::vector<int> input_NIL_index{
		//
		// set the NIL nodes
		//
		8,9,10,11,24,25,26,30,31,54,55,56,57,58,59
	};
	for (auto index : input_NIL_index) {
		input_nodes[index] = NIL;
	}
	using mark_node = std::tuple<int, test_node>;
	std::vector<mark_node> input_tree_nodes{
		//
		// set red black tree nodes
		//
		// {place, data of the node}
		//
		{ 1 ,{0, 5,14} },
		{ 2 ,{0, 2, 3} },
		{ 3 ,{0,30,10} },
		{ 4 ,{0, 1, 1} },
		{ 5 ,{0, 3, 1} },
		{ 6 ,{1,26, 4} },
		{ 7 ,{1,41, 5} },
		{12 ,{0,24, 1} },
		{13 ,{0,28, 2} },
		{14 ,{0,38, 3} },
		{15 ,{0,47, 1} },
		{27 ,{1,29, 1} },
		{28 ,{1,35, 1} },
		{29 ,{1,39, 1} },
	};

	for (auto tree_node : input_tree_nodes) {
		input_nodes[std::get<0>(tree_node)] = std::get<1>(tree_node);
	}

	std::vector<int> input(input_nodes.size() * 3 - 2, -1);
	input[0] = static_cast<int>(input.size());
	for (std::size_t i = 1; i < input_nodes.size(); ++i) {
		for (int j = 0;j < 3;++j) {
			input[3 * i + j - 2] = input_nodes[i][j];
		}
	}


	Insert(input.data(), 3);
	Delete(input.data(), 3);
	int s = Select(input.data(), 3);
	int r = Rank(input.data(), 3);

	system("PAUSE");
}


