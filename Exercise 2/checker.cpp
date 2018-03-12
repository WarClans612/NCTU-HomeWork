#include "algo_hw2.hpp"
#include<iostream>

using namespace std;
#define number 63
#define needed (number*3 + 1)


void print_array(int *arrays, int maximum)
{
    int power = 2;
    for(int i = 0; i < maximum; ++i)
    {
        cout << *(arrays+i) << " ";
        if(i % 3 == 0 && power -1 == i/3)
        {
            cout <<  endl;
            power *= 2;
        }
    }
    cout << endl << "========================================================" << endl;
    return;
}

void initialize_array(int *arrays, int maximum)
{
    for(int i = 1; i < maximum; ++i) *(arrays+i) = -1;
    return;
}

int main()
{
    int insertion[needed];
    initialize_array(insertion, needed);
    insertion[0] = needed;

	Insert(insertion, 5);
	Insert(insertion, 6);
	Insert(insertion, 7);
	Insert(insertion, 4);
	Insert(insertion, 3);
	Insert(insertion, 7);
	Insert(insertion, 10);
	Insert(insertion, 11);
	Insert(insertion, 1);
	Insert(insertion, 5);
	Insert(insertion, 5);
	Insert(insertion, 5);
	Insert(insertion, 1);
	Insert(insertion, 8);
	Insert(insertion, 9);
	Insert(insertion, 10);
	Insert(insertion, 11);
	Insert(insertion, 12);
	print_array(insertion, needed);

	cout << Select(insertion, 1) << " ";
	cout << Select(insertion, 2) << " ";
	cout << Select(insertion, 3) << " ";
	cout << Select(insertion, 4) << " ";
	cout << Select(insertion, 5) << " ";
	cout << Select(insertion, 6) << " ";
	cout << Select(insertion, 7) << " ";
	cout << Select(insertion, 8) << " ";
	cout << Select(insertion, 9) << " ";
	cout << Select(insertion, 10) << " ";
	cout << Select(insertion, 11) << " ";
	cout << Select(insertion, 12) << " ";
	cout << Select(insertion, 13) << " ";
	cout << Select(insertion, 14) << " ";
	cout << Select(insertion, 15) << " ";
	cout << Select(insertion, 16) << " ";
	cout << Select(insertion, 17) << " ";
	cout << Select(insertion, 18) << " ";
    cout << endl << "========================================================" << endl;

	cout << Rank(insertion, Select(insertion, 1)) << " ";
	cout << Rank(insertion, Select(insertion, 2)) << " ";
	cout << Rank(insertion, Select(insertion, 3)) << " ";
	cout << Rank(insertion, Select(insertion, 4)) << " ";
	cout << Rank(insertion, Select(insertion, 5)) << " ";
	cout << Rank(insertion, Select(insertion, 6)) << " ";
	cout << Rank(insertion, Select(insertion, 7)) << " ";
	cout << Rank(insertion, Select(insertion, 8)) << " ";
	cout << Rank(insertion, Select(insertion, 9)) << " ";
	cout << Rank(insertion, Select(insertion, 10)) << " ";
	cout << Rank(insertion, Select(insertion, 11)) << " ";
	cout << Rank(insertion, Select(insertion, 12)) << " ";
	cout << Rank(insertion, Select(insertion, 13)) << " ";
	cout << Rank(insertion, Select(insertion, 14)) << " ";
	cout << Rank(insertion, Select(insertion, 15)) << " ";
	cout << Rank(insertion, Select(insertion, 16)) << " ";
	cout << Rank(insertion, Select(insertion, 17)) << " ";
	cout << Rank(insertion, Select(insertion, 18)) << " ";
    cout << endl << "========================================================" << endl;

	Delete(insertion, 9);
	Delete(insertion, 5);
	Delete(insertion, 7);
	Delete(insertion, 4);
	Delete(insertion, 3);
	Delete(insertion, 7);
	Delete(insertion, 10);
	Delete(insertion, 11);
	Delete(insertion, 5);
	Delete(insertion, 1);
    Delete(insertion, 6);
	Delete(insertion, 8);
	Delete(insertion, 12);
	Delete(insertion, 5);
	print_array(insertion, needed);





    return 0;
}
