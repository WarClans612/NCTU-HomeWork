#ifndef __ASM_HEADER_H__
#define __ASM_HEADER_H__
extern "C" {
	extern void asm_InitObjects();
	extern void asm_updateSimulationNow();
	extern int checkKey();
	extern void clearScreen();
	extern void showTitle();
	extern void asm_EndingMessage();
	extern void asm_SetWindowDimension(int width, int height, int scaledWidth, int scaledHeight);
	extern int asm_GetNumOfObjects();
	extern void asm_GetObjectColor(int &r, int &g, int &b, int objID); //red, green, blue
	extern int asm_GetObjectType( int objID );
	extern int asm_ComputeRotationAngle(int iRad, int objID);
	extern int asm_ComputeObjPositionX(int pos, int objID);
	extern int asm_ComputeObjPositionY(int pos, int objID);
	extern bool asm_HandleKey(int key);
	extern float asm_computeCircularPosX();
	extern bool asm_GetParticleSystemState( );
	extern int asm_GetParticleSize();
	extern void asm_ComputeParticlePosX(double &v);
	extern int asm_ComputeParticlePosY(int x, double &posY, double &velocity);
extern int asm_GetNumParticles();
extern int asm_GetObjPosX();
extern int asm_GetObjPosY();
extern int asm_GetParticleMaxSpeed();
extern int asm_GetImageStatus();
extern int asm_GetImagePixelSize();
extern void asm_GetImageDimension(int &iw, int &ih);
extern void asm_GetImagePos(int &x, int &y);
extern void asm_SetImageInfo(int imageIndex, unsigned char *image, int w, int h, int bytesPerPixels);
extern void asm_GetImageColour(int imageIndex, int ix, int iy, int &r, int &g, int &b); //(x, y), red, green, blue
extern const char *asm_getStudentInfoString();
extern int asm_getImagePercentage();

extern void asm_handleMouseEvent( int button, int state, int x, int y );
extern void asm_handleMousePassiveEvent( int x, int y );
}
namespace ns_myProgram{
extern float resolutionScaleFactor;
};
#endif