static const char* student_id = "0416106" ;

void LCS(int *, int*, int*);

// X,Y are input strings, C is answer string
//
// data structure :
// length of array X is m+1, length of array Y is n+1, length of array C is m+n
// X[0] = m+1, Y[0] = n+1,
// all element of C are "-1"
// other datas are in [0,255] means the symble in ASCII or ANSI table


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
    return;
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
