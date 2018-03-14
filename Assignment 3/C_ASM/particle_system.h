#ifndef __PARTICLE_SYSTEM_H__
#define __PARTICLE_SYSTEM_H__
#include <GL/gl.h>
#include <GL/glut.h>
namespace ns_myProgram
{
class ParticleSystem
{
protected:
	int mMaxNumParticles;
	int mNumParticles;
	double *mPosX, *mPosY;
	double *mVecX, *mVecY;
	int *mR, *mG, *mB;
	int mParticleSize;
public:
	ParticleSystem();
	void update();
	void draw();
};
};
#endif