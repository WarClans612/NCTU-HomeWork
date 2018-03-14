//
// Instructor: Sai-Keung WONG
// Email: cswingo@cs.nctu.edu.tw
// Assembly Language 
//
#ifndef __IMAGE_H__
#define __IMAGE_H__
#include <GL/gl.h>
#include <GL/glut.h>
namespace ns_myProgram
{
	class Image {
	protected:
		int mColorformat[2];
		int mBytePerPixel[2];
		int mTotalBytes[2];
		int mImageWidth[2];
		int mImageHeight[2];
		unsigned char *mImagePtr[2];
	public:
		Image() {
			for (int i = 0; i < 2; ++i) {
			mImageWidth[i] = 0;
			mImageHeight[i] = 0;
			mImagePtr[i] = 0;
			}
		}
		int Read_JPG(int imageIndex, char *fileName);
		~Image() {
			for (int i = 0; i < 2; ++i) {
			if (mImagePtr[i]) {
				delete [] mImagePtr[i];
			}
			mImagePtr[i] = 0;
			}
		}
		void draw(float x0, float y0, float sx, float sy, float point_size);
		void asm_draw(float x0, float y0, float sx, float sy, float point_size);
	};
}; //namespace ns_myProgram

#endif