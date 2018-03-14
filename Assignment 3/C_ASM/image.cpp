#include <windows.h>
#include <iostream>
#include <math.h>
#include <IL/il.h>
#include <IL/ilu.h>
#include <IL/ilut.h>
#include "image.h"
#include "asm_headers.h"
using namespace std;
namespace {
	//-----------------------------------------------------------------------------
	// Name: DXUtil_ConvertAnsiStringToWide()
	// Desc: This is a UNICODE conversion utility to convert a CHAR string into a
	//       WCHAR string. cchDestChar defaults -1 which means it 
	//       assumes strDest is large enough to store strSource
	//-----------------------------------------------------------------------------
	VOID ConvertAnsiStringToWide( WCHAR* wstrDestination, const CHAR* strSource, 
		int cchDestChar )
	{
		if( wstrDestination==NULL || strSource==NULL )
			return;


		if( cchDestChar == -1 )
			cchDestChar = strlen(strSource)+1;


		MultiByteToWideChar( 0, 0, strSource, -1, 
			wstrDestination, cchDestChar-1 );


		wstrDestination[cchDestChar-1] = 0;

	}
};

namespace {
	bool flg_setup_IL = false;
	unsigned int m_imgId;
	void setup_IL() 
	{
		if (flg_setup_IL) return;
		flg_setup_IL = true;
		ilInit();
		iluInit();
		ilutInit();
		ilutRenderer( ILUT_OPENGL );
		ilGenImages( 1, &m_imgId );
		ilBindImage( m_imgId );
	}
};
namespace ns_myProgram
{
	int Image::Read_JPG(int imageIndex, char *a_File)
	{

		cout << "Bgn Image::Read_JPG: " << a_File << endl;
		setup_IL();
		ILboolean success;
		ILenum error;

		//setup_IL();
#ifdef _UNICODE
		wchar_t ILFileName[256];
		ConvertAnsiStringToWide(ILFileName, a_File, -1);
		success = ilLoadImage( ILFileName );

#else
		success = ilLoadImage( a_File );
#endif


		if( !success ){

			while ((error = ilGetError()) !=IL_NO_ERROR) {
				printf("Error %d: %s\n", error, iluErrorString( error ));

			}
			system("pause");
			exit(1);
			//return false;
		}

		mImageWidth[imageIndex] = ilGetInteger( IL_IMAGE_WIDTH );
		mImageHeight[imageIndex] = ilGetInteger( IL_IMAGE_HEIGHT );
		//int sw = 512, sh;
		int sw = 256, sh;
		//sh = mImageHeight[imageIndex]*sw/mImageWidth[imageIndex];
		sw = sh = 256;
		iluScale(sw, sh, 24);
		mImageWidth[imageIndex] = ilGetInteger( IL_IMAGE_WIDTH );
		mImageHeight[imageIndex] = ilGetInteger( IL_IMAGE_HEIGHT );



		int format = ilGetInteger( IL_IMAGE_FORMAT );


		mColorformat[imageIndex] = format;
		switch(format) {
	 case IL_RGBA:
	 case IL_BGRA:
		 mBytePerPixel[imageIndex] = 4;
		 break;
	 case IL_RGB:
		 mBytePerPixel[imageIndex] = 3;
		 break;
		}

		mTotalBytes[imageIndex] = mImageWidth[imageIndex] * mImageHeight[imageIndex]*mBytePerPixel[imageIndex];
		mImagePtr[imageIndex] = (unsigned char*) new unsigned char[mTotalBytes[imageIndex]];

		cout << "mImageWidth:" << mImageWidth << endl;
		cout << "mImageHeight:" << mImageHeight << endl;
		cout << "mBytePerPixel:" << mBytePerPixel << endl;
		cout << "mTotalBytes:" << mTotalBytes << endl;

		ILubyte *p = ilGetData();

		unsigned char *dp = (unsigned char *)mImagePtr[imageIndex];
		unsigned char *sp = (unsigned char *)p;

		switch(format) {
		case  IL_RGBA:
		case IL_BGRA:
			for (int i = 0; i < mTotalBytes[imageIndex]; i++) {
				dp[i] = sp[i];
			}
			break;

		case  IL_RGB:
			for (int i = 0, j = 0; i <  mTotalBytes[imageIndex]; i++) {
				dp[i] = sp[i];

			}
			break;
		}

		asm_SetImageInfo(imageIndex, mImagePtr[imageIndex], mImageWidth[imageIndex], mImageHeight[imageIndex], mBytePerPixel[imageIndex]);

		cout << "End Image::Read_JPG" << endl;

		return true;
	}

	//sx, sz are scaling factors
	void Image::draw(float x0, float y0, float sx, float sy, float point_size)
	{
		if (mImagePtr == 0) return;
		float zLayer = -29.0;
		glPointSize(point_size);
		glBegin(GL_POINTS);
		for (int j = 0; j < mImageHeight[0]; ++j) {
			float y;
			y = y0 + j*sy;
			for (int i = 0; i < mImageWidth[0]; ++i) {
				float x;
				x = x0 + i*sx;
				float r = 1.0, g = 1.0, b = 1.0; //red, green, blue
				int offset = 0;
				offset = j*mImageWidth[0]*mBytePerPixel[0] +i*mBytePerPixel[0];

				//cout << "offset:" << offset << endl;
				r = (float) mImagePtr[0][offset+0];
				g = (float) mImagePtr[0][offset+1];
				b = (float) mImagePtr[0][offset+2];

				//cout << "r:" << r << endl;
				r /= 255.0;
				g /= 255.0;
				b /= 255.0;

				glColor3f(r, g, b); //set colour
				glVertex3f(x,y, zLayer); //define vertex position
			}
		}
		glEnd();
	}

	void Image::asm_draw(float x0, float y0, float sx, float sy, float point_size)
	{
		float zLayer = -29.0;

		if (asm_GetImageStatus( ) == false) return;
		glDisable(GL_LIGHTING);
		glPointSize(point_size);
		glBegin(GL_POINTS);
		for (int j = 0; j < mImageHeight[0]; ++j) {
			float y;
			y = y0 + j*sy;
			for (int i = 0; i < mImageWidth[0]; ++i) {
				float x;
				x = x0 + i*sx;
				int r0 = 1, g0 = 1, b0 = 1; //red, green, blue
				int r1 = 1, g1 = 1, b1 = 1; //red, green, blue

				asm_GetImageColour(0, i, j, r0, g0, b0);
				asm_GetImageColour(1, i, j, r1, g1, b1);
				//cout << "r:" << r << endl;
				
				float rr, gg, bb;
				float t;
				int u = asm_getImagePercentage();
				t = u/(float)255;
				rr = (r0 + t*(r1-r0))/255.0;
				gg = (g0 + t*(g1-g0))/255.0;
				bb = (b0 + t*(b1-b0))/255.0;

				glColor3f(rr, gg, bb); //set colour
				glVertex3f(x,y, zLayer); //define vertex position
			}
		}
		glEnd();
		glEnable(GL_LIGHTING);

	}
};