
#include <mex.h>  
#include "matrix.h"
#include <cstdio>
#include <cstdlib>
#include <math.h>
#include <ctime>
#include <algorithm>


class Mat3d{
public:
	double * mat;
	int Mx, My, Mz;
	Mat3d(){Mx=0; My=0; Mz=0; mat=NULL;}
	
	Mat3d(const mxArray * m){ //prhs[0]
		int numdims1 = (int) mxGetNumberOfDimensions(m);
		const int *dims1 = mxGetDimensions(m);
		Mx = (int)dims1[0];
		My = (int)dims1[1];
		if(numdims1>2){
			Mz = (int)dims1[2];
		}else{
			Mz = 1;
		}
		mat = mxGetPr(m);
	}
	
	
	double getNb(int a, int b, int c){
		return mat[a + Mx*(b + My*c)];
	}
	
};




//[x0,y0]=bestexemplarhelper3(image,good,fullyKnown,cx,cy,dxMin,dxMax,dyMin,dyMax);
void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]) 
{
	int Mx, My, Mz, mm;
	Mat3d image(prhs[0]);
	Mx = image.Mx;
	My = image.My;
	mm=Mx*My;
	Mz = image.Mz;
	//Mat3d good(prhs[1]);
    mxLogical * good = mxGetLogicals(prhs[1]);
	mxLogical * fullyKnown = mxGetLogicals(prhs[2]);
// 	Mat3d fullyKnown(prhs[2]);

	int cx,cy,dxMin,dxMax,dyMin,dyMax;
    /* Extract the inputs */
    cx = (int)mxGetScalar(prhs[3]);
    cy = (int)mxGetScalar(prhs[4]);
    dxMin  = (int)mxGetScalar(prhs[5]);
    dxMax  = (int)mxGetScalar(prhs[6]);
    dyMin = (int)mxGetScalar(prhs[7]);
    dyMax = (int)mxGetScalar(prhs[8]);

	int i, j, ii, x0, y0;
	double dmin, d, temp;
	int u,v,w;
	dmin=1e10;
	ii=0;
	x0=0;
	y0=0;
	for(j=(0-dyMin); j<=(My-1-dyMax); j++){
		for(i=(0-dxMin); i<=(Mx-1-dxMax); i++){
			ii=i+Mx*j;
			if(fullyKnown[ii]){
//             if(fullyKnown.getNb(i,j,0)>0.5){
				d=0;
				for(v=dyMin; v<=dyMax; v++){
					for(u=dxMin; u<=dxMax; u++){
                        if( good[cx+u + Mx*(cy+v)] ){
                            for(w=0;w<Mz;w++){
                                temp=image.getNb(cx+u, cy+v, w) - image.getNb(i+u, j+v, w) ;
                                d+=temp*temp;
                            }
                        }
					}
					if(d>dmin){
						break;
						//goto end;
					}
				}
				if (d < dmin){
					dmin=d;
					x0=i;
					y0=j;
				}
				//end:
			}
		}
	}

	// Output
	mwSize dims3[2]={1,2}; // int = mwSize?
	mxArray *x_mat1 = plhs[0] = mxCreateNumericArray(2,dims3,mxINT32_CLASS,mxREAL);
	int *x_mat = (int *) mxGetData(x_mat1);
	// We add 1 because matlab have another convention than c++
	x_mat[0]=x0+1;
	x_mat[1]=y0+1;
}
