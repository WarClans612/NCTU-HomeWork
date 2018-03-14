//
// Instructor: Sai-Keung WONG
// Email: cswingo@cs.nctu.edu.tw
// Assembly Language 
//
#include <iostream>

#include "asm_headers.h"
#include "opengl_stuff.h"
#include "image.h"
#include "particle_system.h"
#include "shape.h"
//
class SHAPE;
using std::cout;
using std::endl;

#define FILENAME01 "image01.jpg"
#define FILENAME02 "image02.jpg"

namespace ns_myProgram {
	float resolutionScaleFactor = 128.0;
	int windowWidth = 0;
	int windowHeight = 0;
	const int maxNumOfObjects = 2048;
	int totalNumberOfObjects = 0;
	SHAPE *objects[maxNumOfObjects];
	//
	Image *image = 0;
	//
	//Begin forward declaration
	void displaySphere(const int *pos, float rad, int objID);
	void displayRectangle(const int *pos, float rad, int objID);
	void display();
	void initializeObjects();
	void reshape(GLsizei w, GLsizei h);
	void keyboard(unsigned char key, int x, int y);
	void mouseFunc(int button, int state, int x, int y);
	void mousePassiveMouseFunc( int x, int y);
	void idle();
	//
	//End Forward Declaration
	bool keyPressed = false;

	ParticleSystem *particleSystem = 0;

	void initGL(int argc, char *argv[], std::string p_Title)
	{
		image = new Image();
		image->Read_JPG(0, FILENAME01);
		image->Read_JPG(1, FILENAME02);


		particleSystem = new ParticleSystem;

		totalNumberOfObjects = asm_GetNumOfObjects();
		cout << "totalNumberOfObjects:" << totalNumberOfObjects << endl;
		if (totalNumberOfObjects > maxNumOfObjects) {
			totalNumberOfObjects = maxNumOfObjects;
		}
		glutInit(&argc, argv);
		glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
		glutInitWindowSize(800,800);
		glutInitWindowPosition(100,100);
		glutCreateWindow(("Assembly Programming:"+p_Title).data());
		glEnable(GL_DEPTH_TEST);
		initializeObjects( );
		//-----------------------

		GLint param[1] = {1};
		glLightModeliv(GL_LIGHT_MODEL_TWO_SIDE,param);
		glEnable(GL_COLOR_MATERIAL);
		glEnable(GL_LIGHTING);
		glEnable(GL_LIGHT0);
		//glEnable(GL_LIGHT1);
		//-----------------------
		glutDisplayFunc(display);
		glutReshapeFunc(reshape);
		glutKeyboardFunc(keyboard);
		glutMouseFunc(mouseFunc);
		glutPassiveMotionFunc(mousePassiveMouseFunc);

		glutIdleFunc(idle);
		glutMainLoop();
	}




	void initializeObjects()
	{
		std::cout << "totalNumberOfObjects: " << totalNumberOfObjects << std::endl;
		for (int i = 0; i < totalNumberOfObjects; ++i) {
			int type = asm_GetObjectType( i );
			std::cout << "Object Type " << type << std::endl;
			switch(type) {
			case 0:
				objects[i] = new RECTANGLE();
				break;
			case 1:
				objects[i] = new SPHERE();
				break;
			default:
				objects[i] = new SPHERE();
				break;
			}
		}
	}

	extern "C" { // ask C++ compiler not to rename the function
		int c_updatePositionsOfAllObjects()
		{
			for (int i = 0; i < totalNumberOfObjects; i++) {
				objects[i]->update();
			}
			return true;
		}

		int c_sin(int r, int deg)
		{
			return (int)(r*sin(deg/180.0*3.141592654));
		}

		int c_cos(int r, int deg)
		{
			return (int)(r*cos(deg/180.0*3.141592654));
		}

	} // extern "C"

	void update()
	{
		asm_updateSimulationNow();
	}

	void draw()
	{
		for (int i = 0; i < totalNumberOfObjects; i++) {
			objects[i]->draw();
		}	
		if (particleSystem) {
			int flgDrawParticles = asm_GetParticleSystemState( );
			particleSystem->draw();
		}
		if (image) {
			int x0, y0;
			float sx, sy;
			x0 = -300;
			y0 = -300;
			sx = 1.5;
			sy = 1.5;
			float point_size = 1.0;
			int iw, ih;
			asm_GetImageDimension(iw, ih);
			sx = windowWidth/(float) iw;
			sy = windowHeight/(float) ih;
			asm_GetImagePos(x0, y0);
			point_size = asm_GetImagePixelSize();
			image->asm_draw(x0, y0, sx, sy, point_size);
		}
	}

	//===================================================
	void display()
	{
		update();
		//clear color buffer and depth buffer.
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
		draw();
		glutSwapBuffers(); //swap buffers
	}

	void reshape(GLsizei w, GLsizei h) 
	{
		float resFactor = resolutionScaleFactor;
		windowWidth = w;
		windowHeight = h;
		asm_SetWindowDimension(w, h, w*resFactor, h*resFactor);
		glViewport(0, 0, w, h);
		glMatrixMode(GL_PROJECTION);
		glLoadIdentity();
		glOrtho(-w*0.5, w*0.5, -h*0.5, h*0.5, -30.0, 30.0);
		glMatrixMode(GL_MODELVIEW);
		glLoadIdentity();
	}

	void keyboard(unsigned char key, int x, int y) 
	{
		bool state = asm_HandleKey(key);
		if (state == true) return;

		if (key == 27) {
			asm_EndingMessage();
			//std::cout << std::endl;
			//system("pause");
			exit(1);
		}

	}


	void mousePassiveMouseFunc( int x, int y)
	{
		asm_handleMousePassiveEvent( x, y );
	}

	void mouseFunc(int button, int state, int x, int y)
	{
		asm_handleMouseEvent(button, state, x, y);
	}


	void idle()
	{
		glutPostRedisplay(); //ask for drawing the content in the next cycle.
	}

};
