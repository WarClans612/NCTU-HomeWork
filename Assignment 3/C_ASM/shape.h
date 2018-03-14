#ifndef __SHAPE_H__
#define __SHAPE_H__
#include <GL/gl.h>
#include <GL/glut.h>
#include "asm_headers.h"
namespace ns_myProgram
{
	class SHAPE {
		static int mNumOfObjects; //class variable
	protected:
		int mID; //identifier
		int mPos[3]; //position: x, y, z
		int miRad; //rotation angle (radian)
	protected:
		void updatePosition() 
		{

		}

	public:
		SHAPE(){
			mPos[0] = mPos[1] = mPos[2] = 0;
			miRad = 0;
			//
			mID = mNumOfObjects;
			++mNumOfObjects;
		}
		void setPositionY(int posY)
		{
			mPos[1] = posY;
		}
		virtual void update() {
		}
		virtual void draw() {
		}
	};

		class RECTANGLE: public SHAPE {

	public:
		RECTANGLE() {}
		void update()
		{
			float rad = miRad;
			miRad = asm_ComputeRotationAngle(miRad, mID);
			if (miRad > 3600) miRad -= 3600;
			mPos[1] = asm_ComputeObjPositionY(mPos[1], mID);
			mPos[0] = asm_ComputeObjPositionX(mPos[0], mID);

		}
		void draw();

	};

	class SPHERE: public SHAPE {

	public:
		SPHERE() { }
		void update( )
		{
			float rad = miRad;
			miRad = asm_ComputeRotationAngle(miRad, mID);
			if (miRad > 3600) miRad -= 3600;
			mPos[1] = asm_ComputeObjPositionY(mPos[1], mID);
			mPos[0] = asm_ComputeObjPositionX(mPos[0], mID);
			//system("pause");
		}
		void draw();

	};
};

#endif