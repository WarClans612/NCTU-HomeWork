#include <stdio.h>
#include <stdlib.h>
#include <time.h> 
#include <windows.h>
#include <unistd.h>
/*  functions to modified  */
int move_up();
int move_down();
int move_left();
int move_right();
void auto_run();
void run_iteration(int dir);
void print_st_ID();
void print_win_messege();
void movetoXY(int x,int y);

/*  functions not to modified  */
void print_map();
void print_information();
void initialize();
void print_player();
void getCursorXY();
void CursorGotoXY(int x, int y);
char GetInput();

char map[20][23] ={	"*********************",
					"* * * **     ** *   *",
					"* *   *  * *  *   * *",
					"* * * * ** * **** * *",
					"*   * *  * *  *   * *",
					"***** ** * ** * *** *",
					"*     *  * *  *   * *",
					"* ***** ********* * *",
					"*                 * *",
					"** **************** *",
					"*  * *              *",
					"* ** * * ***** ******",
					"*  * * *  *         *",
					"** * * **************",
					"*    *              *",
					"****** **************",
					"*      *            ==",
					"* ******** **********",
					"*                   *",
					"*********************"	
					};
					
int escape_X, escape_Y; 

/*  variables you will use  */
int old_position_X, old_position_Y;
int player_X, player_Y;
int goal;

int main()
{
	print_map();
	print_information();
	initialize();
	print_st_ID();
	char c = '1';
	while(1)
	{
		print_player();
		int hit = kbhit();
		if ( hit )
		{
			int ch = getch();
			if (ch == 119) 		// ASCII code od w
				move_up();
			if (ch == 115) 		// ASCII code od s
				move_down();
			if (ch == 97) 		// ASCII code od a
				move_left();
			if (ch == 100) 		// ASCII code od d
				move_right();
			if (ch == 114) 		// ASCII code od r
				auto_run();
		}
		if( !(goal = 1) ) break;
	}
	print_win_messege();
	return 0;
}

/*  functions to modified  */

int move_up()
{
	// add your code here 
	int sus = 0;
	if( map[player_Y-1][player_X] == ' ')
	{
		player_Y--;
		sus = 1;
 	}
	return sus;
}

int move_down()
{
	// add your code here 
	int sus = 0;
	if( map[player_Y+1][player_X] == ' ')
	{
		player_Y++;
		sus = 1;
	}	
	return sus;
}

int move_left()
{
	// add your code here 
	int sus = 0;
	if( map[player_Y][player_X-1] == ' ')
	{
		player_X--;
		sus = 1;
	}
	return sus;
}

int move_right()
{
	// add your code here 
	int sus = 0;
	if( map[player_Y][player_X+1] == ' ')
	{
		player_X++;
		sus = 1;
	}
	if( map[player_Y][player_X+1] == '=')
	{
		goal = 0;
		sus = 1;
	}
	return sus;
} 

void auto_run()
{
	run_iteration(1);
	return;
} 

void run_iteration(int dir)
{
	Sleep(10); 		// please delay 0.1 second each step 
	// Recursion (DFS)
	int sus;
	int here_X = player_X;
	int here_Y = player_Y;
	if( dir != 1 && goal ) 
	{
		sus = move_up();
		print_player();
		if(sus)
		{
			run_iteration(2);
			if( !goal ) return;
			movetoXY( here_X, here_Y);
		}
	}
	if( dir != 2 && goal ) 
	{
		sus = move_down();
		print_player();
		if(sus)
		{
			run_iteration(1);
			if( !goal ) return;
			movetoXY( here_X, here_Y);
		}
	}
	if( dir != 3 && goal ) 
	{
		sus = move_left();
		print_player();
		if(sus)
		{
			run_iteration(4);
			if( !goal ) return;
			movetoXY( here_X, here_Y);
		}
	}
	if( dir != 4 && goal ) 
	{
		sus = move_right();
		print_player();
		if(sus)
		{
			run_iteration(3);
			if( !goal ) return;
			movetoXY( here_X, here_Y);
		}
	}
	
	return;
}

void movetoXY(int x,int y)
{
	old_position_X = player_X;
	old_position_Y = player_Y;
	player_X = x;
	player_Y = y;
	print_player();
	Sleep(100); 
	return;
}

void print_st_ID()
{
	// add your code here 
	// print from (x,y) = (62,14) 
	
	return;
} 

void print_win_messege()
{
	system("cls");
	CursorGotoXY(20,10);
	printf("*********************************");
	CursorGotoXY(20,11);
	printf("*  You win!! Congratulations!!  *");
	CursorGotoXY(20,12);
	printf("*********************************");
	CursorGotoXY( 40, 21);
	system("pause");
	
	return;	
}

/*  functions not to modified  */
void print_map()
{
	int i, j;
	for( i=0; i<20; i++)
	{
		printf("%s\n", map[i]);
	}
	return;
}

void initialize()
{
	escape_X = 70;
	escape_Y = 21;
	player_X = 1;
	player_Y = 1;
	old_position_X = player_X;
	old_position_Y = player_Y;
	goal = 1;
	return;
}

void print_player()
{
	CursorGotoXY( old_position_X, old_position_Y);
	printf(" ");
	CursorGotoXY( player_X, player_Y);
	printf("O");
	CursorGotoXY( 35, 12);
	printf("You are at %2d, %2d", player_X, player_Y);
	CursorGotoXY( escape_X, escape_Y);
	Sleep( 20 );
	return;
}

void CursorGotoXY(int x, int y) {
	//Initialize the coordinates
	COORD coord = {x, y};
	SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), coord);
	return;
}

void getCursorXY() {
	CONSOLE_SCREEN_BUFFER_INFO csbi;
	if(GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE), &csbi)) {
		player_X = csbi.dwCursorPosition.X;
		player_Y = csbi.dwCursorPosition.Y;

	}
}

char GetInput()
{
	HANDLE input=GetStdHandle(STD_INPUT_HANDLE) ;
	LPDWORD length ;
	INPUT_RECORD record ;
	char ToReturn ;
	while (record.Event.KeyEvent.bKeyDown)
	{
	   ReadConsoleInput(input,&record,1,length) ;
	   ToReturn= record.Event.KeyEvent.uChar.AsciiChar ; 
   	}
	return ToReturn ;
}

void print_information()
{
	CursorGotoXY(40,5);
	printf("\\\\\\\\\\\\  Maze game ///////");
	CursorGotoXY(43,6);
	printf("press 'w' to go up");
	CursorGotoXY(43,7);
	printf("press 'a' to go left");
	CursorGotoXY(43,8);
	printf("press 's' to go down");
	CursorGotoXY(43,9);
	printf("press 'd' to go right");
	CursorGotoXY(43,10);
	printf("press 'r' to automatic run");
	CursorGotoXY(35,14);
	printf("print your student ID here:");
}

