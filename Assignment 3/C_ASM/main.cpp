//
// Instructor: Sai-Keung WONG
// Email: cswingo@cs.nctu.edu.tw
// Assembly Language 
//
#include <math.h>
#include "opengl_stuff.h"
#include "asm_headers.h"


extern "C" {
	extern void asm_ClearScreen();
	extern void asm_ShowTitle();
	extern void asm_InitializeApp();
}

int main(int argc, char *argv[])
{
	asm_ClearScreen();
	asm_ShowTitle();
	asm_InitializeApp( );
	using ns_myProgram::initGL;
	
	initGL( argc, argv, asm_getStudentInfoString() );

	return 0;
}

//===================================================

//


