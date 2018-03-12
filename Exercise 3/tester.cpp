#include <string>
#include <vector>
#include <iostream>
#include <algorithm>
using namespace std;

//Put answer into C depends on lcs_length table
void Fill_answer(int *X, int *Y, int **lcs_length, int i, int j, int n, int *C)
{
    if (i < 1 || j < 1) return;
    if ( *(X+i) == *(Y+j))
    {
        Fill_answer(X, Y, lcs_length, i-1, j-1, n-1, C);
        *(C+n) = *(X+i);
    }
    else if (lcs_length[i-1][j] >= lcs_length[i][j-1]) Fill_answer(X, Y, lcs_length, i-1, j, n, C);
    else Fill_answer(X, Y, lcs_length, i, j-1, n, C);
}

void LCS(int* X, int* Y, int* C) {
    //Declaring 2D array using new
    int **lcs_length = new int* [*X];
    for (int i = 0; i < *X; ++i)
    {
        lcs_length[i] = new int[*Y];
    }

    //Initialization
    for (int i = 1; i < *X; ++i) lcs_length[i][0] = 0;
    for (int i = 0; i < *Y; ++i) lcs_length[0][i] = 0;

    for (int i = 1; i < *X; ++i)
    {
        for (int j = 1; j < *Y; ++j)
        {
            if (*(X+i) == *(Y+j)) lcs_length[i][j] = lcs_length[i-1][j-1] + 1;
            else if (lcs_length[i-1][j] >= lcs_length[i][j-1]) lcs_length[i][j] = lcs_length[i-1][j];
            else lcs_length[i][j] = lcs_length[i][j-1];
        }
    }

    Fill_answer(X, Y, lcs_length, *X - 1, *Y - 1, lcs_length[*X-1][*Y-1] - 1, C);

    //Deletion of 2D array
    for (int i = 0; i < *X; ++i)
    {
        delete [] lcs_length[i];
    }
    delete [] lcs_length;

    return;
}

int main()
{
	using std::vector;
	using std::string;
	using std::cout;

	string string1{"0BDCABA"};//{"0PenPineappleApplePen"};
	string string2{"0ABCBDAB"};//{"0NOT_PPAP"};

	vector<int> X(string1.begin(), string1.end());
	vector<int> Y(string2.begin(), string2.end());
	vector<int> C(X.size() + Y.size(),-1);
	vector<int> ANS(C.begin(), C.end());

	X[0] = X.size();
	Y[0] = Y.size();

    LCS(X.data(), Y.data(), C.data());

    for(int i = 0; i < C.size(); ++i) cout << C[i];
}
