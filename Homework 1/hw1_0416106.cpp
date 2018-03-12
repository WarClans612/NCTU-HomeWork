#include<stdio.h>
#include<stdlib.h>

//Function to make all character to lower case
char lower_case(char c)
{
    if( c >= 'A' && c <= 'Z' ) c = c - 'A' + 'a';
    return c;
}

//Check if the input is lowercase character on not
bool check_char( char c )
{
    if( c >= 'a' && c <= 'z' ) return true;
    return false;
}

//If it is punctuation mark or enter
bool punctuation ( char c )
{
    if( !check_char(c) && !(c >= '0' && c <= '9') ) return true;
    return false;
}

int main(int argc, char *argv[])
{
    //Declaring file pointer
    FILE *finput;
    FILE *foutput;

    //Input and output file from user typed
    {
        char file[100] = {'\0'};
        printf("Please type input and output file separated by space: ");
        scanf("%s", file);
        finput = fopen( file, "r");
        scanf("%s", file);
        foutput = fopen( file, "w");
    }

    //Calculating keyword length
    int key_length = 0;
    char ch;
    while(fscanf(finput, "%c", &ch) != EOF)
    {
        ch = lower_case( ch );
        if( !punctuation( ch ) ) ++key_length;
        else break;
    }

    //Rewinding back the file pointer to the beginning
    rewind(finput);

    //Inputting the keyword from file
    char *keyword;
    keyword = (char*)malloc (key_length * sizeof(char));
    for(int i = 0; i < key_length; ++i)
    {
        fscanf(finput, "%c", keyword+i);
        *(keyword+i) = lower_case ( *(keyword+i) );
    }

    //Rewinding back the file pointer to the beginning
    rewind(finput);

    //Generating failure function
    int *fail_function;
    fail_function = (int*) malloc(key_length * sizeof(int));
    fail_function[0] = 0;
    for(int first = 1, second = 0; first < key_length; ++first)
    {
        //If the keyword of first and second is different
        if( keyword[first] != keyword[second] )
        {
            //If the second word is already the head, then it means it has 0 failure function value
            if ( second == 0 ) fail_function[first] = 0;
            //If it is not, then iterate back depends on value behind it
            else
            {
                second = fail_function[second-1];
                --first;
            }
        }
        else
        {
            //If first and second keyword character is the same
            fail_function[first] = second + 1;
            ++second;
        }
    }

    //Searching for the keyword's frequency not including substring
    bool valid = true;
    int frequency = 0;
    //fscanf( finput, "%c", &ch);
    for(int i = 0; fscanf( finput, "%c", &ch) != EOF;)
    {
        ch = lower_case( ch );
        if(valid == true)
        {
            //If it is same, then keep comparing
            if( ch == keyword[i] ) ++i;
            else valid = false;

            //If we get all same word for the keyword
            if(i == key_length)
            {
                i = 0;
                valid = false;
                //If the next input is not character
                if (fscanf( finput, "%c", &ch) != EOF)
                {
                    ch = lower_case( ch );
                    //If the next input is not a character, then it is considered a valid word
                    if( punctuation( ch )) {++frequency; valid = true;}
                }
                else {++frequency; valid = true;}
            }
        }
        //If it is space then we re-compare the keyword
        if( punctuation( ch ) )
        {
            i = 0;
            valid = true;
        }
    }
    fprintf( foutput, "%d\n", frequency );

    //Rewinding back the file pointer to the beginning
    rewind(finput);

    //Searching for substring
    //Pattern is address location of the word in the keyword array
    int pattern = 0, word = 1;
    valid = true;
    while(fscanf( finput, "%c", &ch) != EOF)
    {
        ch = lower_case( ch );
        //If we met some space, it means we have new words
        if( valid == true && punctuation( ch )) {valid=false; ++word;}
        else if( !punctuation( ch )) valid = true;
        //If the character in text and keyword match, then increment to the next character
        if( ch == keyword[pattern] ) ++pattern;
        //If not the same, then check the failure function for the appropriate checking position
        else while( pattern != 0 && ch != keyword[pattern])
        {
            pattern = fail_function[pattern-1];
            if( ch == keyword[pattern] ) {++pattern; break;}
        }


        //If we have found complete match, then print the answer
        if(pattern >= key_length)
        {
            fprintf(foutput, "%d", word);
            if(pattern != 0) pattern = fail_function[pattern-1];
            else pattern = 0;
        }
    }

    //Print some message
    printf("\n\n\n----------------------------------------------------------------------------\n");
    printf("Your answer will be printed in the desired place you have inputted\n");

    //Closing file
    fclose(finput);
    fclose(foutput);
    //Freeing pointer
    free(keyword);
    free(fail_function);

    return 0;
}
