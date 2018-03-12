#include "algo_hw3.hpp"

#include <string>
#include <vector>
#include <iostream>
#include <algorithm>

int main() {

	using std::vector;
	using std::string;
	using std::cout;

	string string1{"0PenPineappleApplePen"};
	string string2{"0NOT_PPAP"};

	vector<int> X(string1.begin(), string1.end());
	vector<int> Y(string2.begin(), string2.end());
	vector<int> C(X.size() + Y.size(),-1);
	vector<int> ANS(C.begin(), C.end());

	X[0] = X.size();
	Y[0] = Y.size();


	LCS(X.data(), Y.data(), C.data());


	int lcs_ans = 4;
	int counter{};
	for (auto i : C) {
		if (i != -1) {
			++counter;
		}
	}
	
	cout << "LCS length is " << (counter == lcs_ans) << '\n';

	string EXPECT{ "PPAP" };
	for (auto i = 0; i < EXPECT.size(); ++i) {
		ANS[i] = static_cast<int>(EXPECT[i]);
	}
	
	cout << "answer string is " << std::equal(C.begin(),C.end(), ANS.begin()) << '\n';

}