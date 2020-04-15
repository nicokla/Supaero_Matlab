
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




// x0y0=bestExemplarHelper2(image, histoAll, histoPatch,fullyKnown,...
//           cx,cy,dxMin,...
// 		  dxMax,dyMin,dyMax);
void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]) 
{
	int Mx, My, Mz, mm, N;
	Mat3d image(prhs[0]);
	Mx = image.Mx;
	My = image.My;
	mm=Mx*My;
	Mz = image.Mz;
	Mat3d histoAll(prhs[1]);
    N=histoAll.Mz;
    Mat3d histoPatch(prhs[2]);
	mxLogical * fullyKnown = mxGetLogicals(prhs[3]);
// 	Mat3d fullyKnown(prhs[3]);
            
	int cx,cy,dxMin,dxMax,dyMin,dyMax;
    /* Extract the inputs */
    cx = (int)mxGetScalar(prhs[4]);
    cy = (int)mxGetScalar(prhs[5]);
    dxMin  = (int)mxGetScalar(prhs[6]);
    dxMax  = (int)mxGetScalar(prhs[7]);
    dyMin = (int)mxGetScalar(prhs[8]);
    dyMax = (int)mxGetScalar(prhs[9]);

	int i, j, ii, x0, y0;
	double dmin, d, temp, d2;
	int u,v,w;
	dmin=1e10;
	ii=0;
	x0=0;
	y0=0;
	for(j=(0-dyMin); j<=(My-1-dyMax); j++){
		for(i=(0-dxMin); i<=(Mx-1-dxMax); i++){
			ii=i+Mx*j;
// 			if(fullyKnown.getNb(i,j,0)>0.5){
            if(fullyKnown[ii]){
				d=0;
				for(v=dyMin; v<=dyMax; v++){
					for(u=dxMin; u<=dxMax; u++){
                        for(w=0;w<Mz;w++){
                            temp=image.getNb(cx+u, cy+v, w) - image.getNb(i+u, j+v, w) ;
                            d+=temp*temp;
                        }
					}
// 					if(d>dmin){
// 						break;
// 					}
				}
                d=sqrt(d);
                
                d2=0;
                for(v=0;v<N;v++){
                    d2=d2+sqrt(histoAll.getNb(i,j,v)*histoPatch.getNb(v,0,0));
                }
                d2=sqrt(1-d2);
                        
                d=d*d2;
				if (d < dmin){
					dmin=d;
					x0=i;
					y0=j;
				}
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
