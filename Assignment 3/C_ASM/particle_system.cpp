#include <windows.h>
#include <math.h>
#include "particle_system.h"
#include "asm_headers.h"
namespace ns_myProgram
{


ParticleSystem::ParticleSystem()
{
	mMaxNumParticles = 200000;
	mParticleSize = 1;
	mNumParticles = 5000;
	mPosX = new double[mMaxNumParticles];
	mPosY = new double[mMaxNumParticles];
	mVecX = new double[mMaxNumParticles];
	mVecY = new double[mMaxNumParticles];
	mR = new int[mMaxNumParticles];
	mG = new int[mMaxNumParticles];
	mB = new int[mMaxNumParticles];

	for (int i = 0; i < mMaxNumParticles; ++i )
	{
		double angle = (rand()%10000)/10000.0*3.1415*2.0;
		double vx = cos(angle);
		double vy = sin(angle);
		double r = 15*(rand()%2000+1)/2000.0*asm_GetParticleMaxSpeed()/resolutionScaleFactor;

		mPosX[i] = (rand()%2000)/2000.0;
		mPosY[i] = (rand()%2000)/2000.0;
		mVecX[i] = vx*r;
		mVecY[i] = vy*r;
		if (mVecX[i] == 0) mVecX[i] = 1+(rand()%2);
		if (mVecY[i] == 0) mVecY[i] = 1+(rand()%2);
		mR[i] = (rand()%195)+60;
		mG[i] = (rand()%195)+60;
		mB[i] = (rand()%195)+60;

	}
}

void ParticleSystem::draw()
{
	mParticleSize = asm_GetParticleSize();
	mNumParticles = asm_GetNumParticles();
	static int counter = 0;
	++counter;
	//if ((counter%10) == 0) {
		for (int i = 0; i < mNumParticles; ++i )
		{
			mPosX[i] += mVecX[i];
			mPosY[i] += mVecY[i];
			double x = mPosX[i];
			x = x*resolutionScaleFactor;
			//asm_ComputeParticlePosX(x);
			mPosX[i] = x/resolutionScaleFactor;
			;
			double y = mPosY[i];
			y = y*resolutionScaleFactor;
			double vy = mVecY[i];
			//bool flg = asm_ComputeParticlePosY(x, y, vy);
			mPosY[i] = y/resolutionScaleFactor;
			mVecY[i] = vy;
			

		}
	//}
	glPointSize(mParticleSize);
	//glEnable(GL_POINT_SMOOTH);
	static float b = 0;
	static float c = 200.0;
	glBegin(GL_POINTS);
	b = c;
	for ( int i = 0; i < mNumParticles; ++i )
	{
		//b += (i%23);
		//if (b > 200) b = 1;
		float f = b/200.0;
		glColor3f(f*mR[i]/255.0, f*mG[i]/255.0, f*mB[i]/255.0);
		glNormal3f(0, 0, 1);
		glVertex3f(mPosX[i], mPosY[i], 0);
	}
	glEnd();
	//c += 1;
	//if (c > 200) c = 0;

}
};