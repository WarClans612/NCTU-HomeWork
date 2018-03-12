//
// just easy test for you,
// not real test environments and datas
//

#include "algo_hw2.hpp"

#include <vector>
#include <vector>
#include <vector>
#include <vector>
#include <iostream>
#include <algorithm>
#include <iostream>
#include <vector>
#include <array>
#include <tuple>

#include <cassert>
#include <cstddef>
#include <cstdlib>

const std::array<int, 3> Empty{ -1, -1, -1 };
const std::array<int, 3> NIL{ 0, 0, 0 };

const int full_complete_size = 63;
std::vector<int> insert_tree(full_complete_size * 3 + 1, -1);
std::vector<int> delete_tree(full_complete_size * 3 + 1, -1);
std::vector<int> delete_check(full_complete_size * 3 + 1, -1);

int main(int argc, char **argv) {
	using test_node = std::array<int, 3>;
	using mark_node = std::tuple<int, test_node>;
	std::cout << student_id << "'s homework \n";

	insert_tree[0] = static_cast<int>(insert_tree.size());
	Insert(insert_tree.data(), 5);
	Insert(insert_tree.data(), 6);
	Insert(insert_tree.data(), 7);
	std::vector<test_node> expect_insert_nodes(full_complete_size + 1, Empty);
	std::vector<int> expect_insert_NIL_index{
		//
		// set the NIL nodes
		//
		4,5,6,7
	};
	for (auto index : expect_insert_NIL_index) {
		expect_insert_nodes[index] = NIL;
	}

	test_node x1{0, 6, 3};
	test_node x2{1, 5, 1};
	test_node x3{1, 7, 1};
	mark_node m1{1, x1};
	mark_node m2{2, x2};
	mark_node m3{3, x3};
	std::vector<mark_node> expect_insert_tree{
		//
		// set red black tree nodes
		//
		// {place, data of the node}
		//
		m1,
		m2,
		m3,
	};
	for (auto tree_node : expect_insert_tree) {
		expect_insert_nodes[std::get<0>(tree_node)] = std::get<1>(tree_node);
	}

	delete_tree[0] = static_cast<int>(delete_tree.size());
	for (std::size_t i = 1; i < expect_insert_nodes.size(); ++i) {
		for (int j = 0;j < 3;++j) {
			delete_tree[3 * i + j - 2] = expect_insert_nodes[i][j];
		}
	}

	bool res = true;
	for (int i = 1; i < full_complete_size + 1; ++i) {
		res &= (delete_tree[3 * i - 2] == insert_tree[3 * i - 2]);
		res &= (delete_tree[3 * i - 1] == insert_tree[3 * i - 1]);
	}
	std::cout << "Insert is " << res << "\n";



	Delete(delete_tree.data(), 3);
	Delete(delete_tree.data(), 5);
	Delete(delete_tree.data(), 7);
	std::vector<test_node> expect_delete_nodes(full_complete_size + 1, Empty);
	std::vector<int> expect_delete_NIL_index{
		//
		// set the NIL nodes
		//
		2,3,
	};
	for (auto index : expect_delete_NIL_index) {
		expect_delete_nodes[index] = NIL;
	}

	test_node y1{0,6 ,1};
	mark_node n1{1,y1};

	std::vector<mark_node> expect_delete_tree{
		//
		// set red black tree nodes
		//
		// {place, data of the node}
		//
		n1
	};




	for (auto tree_node : expect_delete_tree) {
		expect_delete_nodes[std::get<0>(tree_node)] = std::get<1>(tree_node);
	}
	delete_check[0] = static_cast<int>(delete_tree.size());
	for (std::size_t i = 1; i < expect_delete_nodes.size(); ++i) {
		for (int j = 0;j < 3;++j) {
			delete_check[3 * i + j - 2] = expect_delete_nodes[i][j];
		}
	}

	res = true;
	for (int i = 1; i < full_complete_size + 1; ++i) {
		res &= (delete_tree[3 * i - 2] == delete_check[3 * i - 2]);
		res &= (delete_tree[3 * i - 1] == delete_check[3 * i - 1]);
	}
	std::cout << "Delete is " << res << "\n";

	system("pause");
}


