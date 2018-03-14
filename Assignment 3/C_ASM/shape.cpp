#include <windows.h>
#include "shape.h"


namespace ns_myProgram
{
		//p : position
	void displaySphere(const int *p, float rad, int objID)
	{
		float resFactor = resolutionScaleFactor;
		int r = 255, g = 255, b = 255;
		asm_GetObjectColor(r, g, b, objID);
		glColor3f(r/255.0, g/255.0, b/255.0);
		glMatrixMode(GL_MODELVIEW);
		glPushMatrix();
		glTranslatef(p[0]/resFactor, p[1]/resFactor, p[2]/resFactor);
		glRotatef(rad, 0, 1, 0);
		glScalef(0.35, 0.35, 0.35);
		glutSolidSphere(30, 8, 8);
		glPopMatrix();
	}
	//pos : position
	void displayRectangle(const int *pos, float rad, int objID)
	{

		float resFactor = resolutionScaleFactor;
		int w, h;
		w = 20;
		h = 20;
		int r = 255, g = 255, b = 255;
		asm_GetObjectColor(r, g, b, objID);
		//setColorMaterial(r/255.0, g/255.0, b/255.0);
		glColor3f(r/255.0, g/255.0, b/255.0);
		glMatrixMode(GL_MODELVIEW);

		glPushMatrix();
		glTranslatef(pos[0]/resFactor, pos[1]/resFactor, pos[2]/resFactor);
		glRotatef(rad, 0, 1, 0);
		glBegin(GL_QUADS);
		glNormal3f(1, 0, 0); // normal vector
		glVertex2f(0, 0);
		glNormal3f(0, 1, 0); // normal vector
		glVertex2f(w, 0);
		glNormal3f(1, 0, 1); // normal vector
		glVertex2f(w, h);
		glNormal3f(0, 0, 1); // normal vector
		glVertex2f(0, h);
		glEnd();
		glPopMatrix();
	}

	//pos : position
	void displaySquare(const float *pos)
	{
		int w, h;
		w = 10;
		h = 10;
		glMatrixMode(GL_MODELVIEW);
		glPushMatrix();
		glColor3f(0.1, 1, 0.5);
		glTranslatef(pos[0], pos[1], pos[2]);
		//glRotatef(pos[0], 0, 1, 0);
		glBegin(GL_QUADS);
		glNormal3f(1, 0, 0); // normal vector
		glVertex3f(0, 0, 2);
		glVertex3f(w, 0, 2);
		glVertex3f(w, h, 2);
		glVertex3f(0, h, 2);
		glEnd();
		glPopMatrix();
	}

	void RECTANGLE::draw() {
			displayRectangle(mPos, miRad/resolutionScaleFactor, mID);
		}

	void SPHERE::draw() {
			displaySphere(mPos, miRad/10.0, mID);
		}
	int SHAPE::mNumOfObjects = 0;


};