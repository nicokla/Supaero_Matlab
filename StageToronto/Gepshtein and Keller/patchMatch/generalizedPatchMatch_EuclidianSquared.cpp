// -----------------
// Inputs :
// imageToComplete=[1 2 3;4 5 6]; = image1
// imageUsed=ones(4); = image2
// nbEtapes=5;
// k=2;
// good1
// good2
// -----------------
// Outputs :
// x_mat (Mx*My*k)
// y_mat (Mx*My*k)
// d_mat (Mx*My*k)
//         returns distanceEuclidienne ^ 2
////////////////////////////
// [x,y,d]=pm(b,c,nbEtapes,k,good1,good2);
//////////////////////

#include <mex.h>  
#include "matrix.h"
#include <cstdio>
#include <cstdlib>
#include <math.h>
#include <ctime>
#include <algorithm>


///////////////////////
// defines from the original code from Barnes et al.
#define XY_TO_INT(x, y) (((y)<<12)|(x))
#define INT_TO_X(v) ((v)&((1<<12)-1))
#define INT_TO_Y(v) ((v)>>12)
#define XY_TO_INT_SHIFT 12

#define NHASH 256
#define NHASH_M1 (NHASH-1)
#define HASH_FUNC(xv, yv) (((xv)+(yv)*3829)&(NHASH_M1))



//////////////////////////////////////////////
///////////// Begin hash set //////////////////
// Comes from the original Barnes et al. implementation
// of patch match


class PositionLink { public:
  int v;
  PositionLink *next;
};

// Declaration : PositionSet pos(k);
/* Hash table of fixed size for positions, much faster (10x or more) than STL if few/no collisions. Max size is NHASH. */
class PositionSet { public:
  PositionLink *item[NHASH];
  PositionLink item_data[NHASH];
  PositionLink *free_item;
  
//   PositionSet() {
//   }

  void init() { // int nhash_
    for (int i = 0; i < NHASH; i++) { item[i] = NULL; }
    for (int i = 0; i < NHASH-1; i++) { item_data[i].next = &item_data[i+1]; }
    item_data[NHASH-1].next = NULL;
    free_item = &item_data[0];
  }
  
  PositionSet() { //int nhash_
    init(); //init(nhash_)
  }

  int contains(int xv, int yv) {
    int h = HASH_FUNC(xv, yv);
    PositionLink *current = item[h];
    while (current) {
      if (current->v == XY_TO_INT(xv, yv)) { return 1; }
      current = current->next;
    }
    return 0;
  }
  
	/* If element not in set, insert it and return 1.  If element in set, do nothing and return 0. */
  int try_insert(int xv, int yv) {
    int h = HASH_FUNC(xv, yv);
    int pnni = XY_TO_INT(xv, yv);
    PositionLink *current = item[h];
    while (current) {
      if (current->v == pnni) { return 0; }
      current = current->next;
    }
    PositionLink *add = free_item;
    free_item = free_item->next;
    if (!free_item) { fprintf(stderr, "hash table full\n"); exit(1); }
    add->v = pnni;
    add->next = item[h];
    item[h] = add;
    return 1;
  }
  
  /* Insert an element that's not in the set. */
  void insert_nonexistent(int xv, int yv) {
    int h = HASH_FUNC(xv, yv);
    int pnni = XY_TO_INT(xv, yv);
    PositionLink *add = free_item;
    free_item = free_item->next;
    if (!free_item) { fprintf(stderr, "hash table full\n"); exit(1); }
    add->v = pnni;
    add->next = item[h];
    item[h] = add;
  }
  
  /* Remove an element that's in the set. */
  void remove(int xv, int yv) {
    int h = HASH_FUNC(xv, yv);
    int pnni = XY_TO_INT(xv, yv);
    PositionLink **prev = &item[h];
    PositionLink *current = item[h];
    while (current) {
      if (current->v == pnni) {
        *prev = current->next;
        current->next = free_item;
        free_item = current;
        return;
      }
      prev = &current->next;
      current = current->next;
    }
    fprintf(stderr, "remove with nonexistent element: %d %d\n", xv, yv); exit(1);
  }
};

/////////////////// End hash set /////////////////////////
///////////////////////////////////////////////////




//////////////////////////
using std::max;
using std::min;
using std::ceil;

// typedef struct mat3d_{
// 	double * mat;
// 	int Mx, My, Mz;
// 	double getNb(int a, int b, int c){
// 		return mat[a + b*Mx + c*Mx*My];
// 	}
// }Mat3d;

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

class XyCoord{ public:
    double d;
    int x;
    int y;
    void set(double d_, int x_, int y_){
        d=d_; x=x_; y=y_;
    }
};

// typedef struct xyCoord_{
// 	double d;
// 	int x;
// 	int y;
// }XyCoord;



////////////////////////////////////////////////
// MaxHeap comes from
//  http://www.codeproject.com/Tips/816934/Min-Binary-Heap-Implementation-in-Cplusplus
// by Anton Kaminsky
// template <class key, class value>
// template <unsigned int k0>
class MaxHeap
{
public:

// XyCoord mat[k0];
XyCoord * mat;
int nbElements;
XyCoord temp;

void BubbleUp(int index){
	if(index==0)
		return;
	
	int parentIndex = (index-1)/2;
	if(mat[parentIndex].d < mat[index].d){
		temp = mat[parentIndex];
		mat[parentIndex] = mat[index];
		mat[index] = temp;
		BubbleUp(parentIndex);
	}
}

	
void BubbleDown(int index)
{
	int leftChildIndex = 2*index + 1;
	int rightChildIndex = 2*index + 2;

	if(leftChildIndex >= nbElements)
		return; //index is a leaf

	int minIndex = index;

	if(mat[index].d < mat[leftChildIndex].d){
		minIndex = leftChildIndex;
	}
	
	if((rightChildIndex < nbElements) && (mat[minIndex].d < mat[rightChildIndex].d)){
		minIndex = rightChildIndex;
	}

	if(minIndex != index){
		temp = mat[index];;
		mat[index] = mat[minIndex];
		mat[minIndex] = temp;
		BubbleDown(minIndex);
	}
}
	
MaxHeap(){
	nbElements=0;
}

void DeleteMax(){
    if(nbElements > 0){
		mat[0] = mat[nbElements-1];
		nbElements--;
		BubbleDown(0);
	}
}

// pas de check
// dans le programme, a utiliser juste au debut pour remplir avec les aleatoires
void insert(double newValue, int xval, int yval){
	nbElements++; 
	mat[nbElements-1].d=newValue;
	mat[nbElements-1].x=xval;
	mat[nbElements-1].y=yval;
	BubbleUp(nbElements-1);
}

// ne prends pas qqchose s'il est plus distant que le plus distant actuel
/* void insert2(double newValue, int xval, int yval){
	if(nbElements == k0 && newValue<mat[0].d){
		DeleteMax();
		insert(newValue,xval, yval);
	}else if(nbElements < k0){
		insert(newValue,xval, yval);
	}//else if(newValue>=mat[0].d){}	
} */

};

//////////////// End min_heap /////////////////
/////////////////////////////////////////////////

// it's the square dist but we don't care because it doesn't
// change the ordering.
// without possibility of early termination
double getDist_old(Mat3d &image3d1, Mat3d &image3d2, int i, int j, int a, int b){
	double temp, d=0;
	int n;
	for(n=0; n < image3d1.Mz; n++){
		temp = image3d1.getNb(i,j,n) -
			   image3d2.getNb(a,b,n);
		d += temp*temp;
	}
	return d;
}


// with possibility of early termination
/* double getDist(Mat3d &image3d1, Mat3d &image3d2, int i, int j, int a, int b, double distMax){
	double temp, d=0;
	int n;
	for(n=0; n < image3d1.Mz; n++){
		temp = image3d1.getNb(i,j,n) -
			   image3d2.getNb(a,b,n);
		d += temp*temp;
		if (d > distMax) { return d; } // early termination to go faster
	}
	return d;
}
 */
double getDist(Mat3d &image3d1, Mat3d &image3d2, int i, int j, int a, int b, double distMax){
	double temp, d=0;
	
	int step=max(1, image3d1.Mz/10);
	int nbStep=image3d1.Mz/step;
	int n, n2, n3=0;
	for(n=0; n<nbStep; n++){
		for(n2=0; n2<step; n2++){
			temp = image3d1.getNb(i,j,n3) -
				   image3d2.getNb(a,b,n3);
			d += temp*temp;
			n3++;
		}
		if (d > distMax) { return d; } // early termination to go faster
	}
	
	while(n3<image3d1.Mz){
		temp = image3d1.getNb(i,j,n) -
			   image3d2.getNb(a,b,n);
		d += temp*temp;
		n3++;
	}
		
	return d;
}

 
int randBetween(int a, int b){
	return a+(rand()%(b-a+1));
}

// MaxHeap * m, int i2 --> m[i2]
void knn_attempt_n(MaxHeap &mi2, int i, int j, 
        int a, int b, PositionSet &pos0,
        Mat3d &image3d1, Mat3d &image3d2,
        Mat3d good1, Mat3d good2){
	//int deltaX = a-i;
	//int deltaY = b-j;
	if(pos0.contains(a, b) || 
            (
            (good2.getNb(a,b,0) < 0.5) //&& (good1.getNb(i,j,0) > 0.5)
            )
       ) {
		return;
	}
	 
	double distMax = mi2.mat[0].d;
	double d=getDist(image3d1, image3d2, i, j, a, b, distMax);
	if(d < mi2.mat[0].d){
		pos0.remove(mi2.mat[0].x, mi2.mat[0].y);
		mi2.DeleteMax();
		mi2.insert(d, a, b);
		pos0.insert_nonexistent(a, b);
	}
}






/////////////////////////////////////////
// Main function
/////////////////////////////////////////
// imageToComplete=[1 2 3;4 5 6]; = image1
// imageUsed=ones(4); = image2
// nbEtapes=5;
// k=2;
// good1
// good2
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

mexPrintf("Beginning of patch match.\n");
mexEvalString("drawnow;");

// On initialise les nombres aleatoires
srand((unsigned int)time(NULL));
	
double alpha=0.5;
int a,b;
double d;
int i, j, l, n;

double temp;

double * k_mat = mxGetPr(prhs[3]);
int k= (int)k_mat[0];
double * nbSteps_mat = mxGetPr(prhs[2]);
int nbSteps= (int)nbSteps_mat[0];
//int k=(int)mxGetScalar(prhs[3]);
//int nbSteps=(int)mxGetScalar(prhs[2]);

int Mx1, My1, Mz1;
Mat3d image3d1(prhs[0]);
Mx1 = image3d1.Mx;
My1 = image3d1.My;
Mz1 = image3d1.Mz;

int Mx2, My2, Mz2;
Mat3d image3d2(prhs[1]);
Mx2 = image3d2.Mx;
My2 = image3d2.My;
Mz2 = image3d2.Mz;

Mat3d good1(prhs[4]);
Mat3d good2(prhs[5]);

//MaxHeap<k> m[Mx*My];
// MaxHeap<K_MAX> * m = (MaxHeap<K_MAX>*)mxCalloc(Mx1*My1,sizeof(MaxHeap<K_MAX>));
MaxHeap * m = (MaxHeap*)mxCalloc(Mx1*My1,sizeof(MaxHeap));
XyCoord * m2 = (XyCoord *)mxCalloc(Mx1*My1*k,sizeof(XyCoord));
int i2=0;
for(j=0; j<My1; j++){//l
	for(i=0; i<Mx1; i++){
		//i2 = i + j*Mx3;
        m[i2].mat=&(m2[i2*k]);
        m[i2].nbElements=0;
		//m[i2]=MaxHeap(k);
		//m[i2].mat=mxCalloc(...)
        i2++;
	}
}

XyCoord * m3 = (XyCoord *)mxCalloc(k,sizeof(XyCoord));
MaxHeap m4;
m4.mat=m3;
m4.nbElements=0; 

PositionSet chosen;
for(i=0; i<Mx1; i++){
	for(j=0; j<My1; j++){
		chosen.init();
		for(l=0; l<k; l++){
			while(1){
				a = rand() % Mx2;
				b = rand() % My2;
				if (chosen.try_insert(a, b) && 
                    (
                        (good2.getNb(a,b,0) > 0.5) 
                        //||(good1.getNb(i,j,0) < 0.5)
                    )
                    ) {
					d = getDist_old(image3d1, image3d2, i, j, a, b );
					m[i+Mx1*j].insert(d, a, b);
					break;
				}
			}
		}
	}
}


/////////////////////////////////////////
// Algorithm
i2=0;
int i3=0;
XyCoord coucou;
int maxi0 = max(Mx2,My2);
int iStep, pas, debutX, debutY, finX, finY, xORy, pasX, pasY;
double semiSize2;
int g;
int minX, minY, maxX, maxY;
int xrand, yrand;
PositionSet pos; pos.init();
int x, y;
// double d;

for(iStep=1;iStep<=nbSteps;iStep++){ //
    mexPrintf("Beginning of step %d.\n", iStep);
    mexEvalString("drawnow;");
	if(iStep%2){
		pas=1;
		debutX=1;
		debutY=1;
		finX=Mx1-1;
		finY=My1-1;
	}else{
		pas=-1;
		finX=0;
		finY=0;
		debutX=Mx1-2;
		debutY=My1-2;
	}

	for(i=debutX; i!=(finX+pas); i+=pas){
		for(j=debutY; j!=(finY+pas); j+=pas){
            
            //     Debut pour (i,j)
			i2=i+Mx1*j;
			
			pos.init();
			for (int ii = 0; ii < k; ii++) {
                coucou=m[i2].mat[ii];
				pos.insert_nonexistent(coucou.x, coucou.y);
			}

			// Propagation
			for(xORy=0; xORy<=1; xORy++){
				pasX = (-pas)*xORy;
				pasY = (-pas)*(1-xORy);
				i3 = i+pasX + Mx1*(j+pasY);
				for(l=0;l<k;l++){
					coucou = m[i3].mat[l];
					a=coucou.x - pasX;
					a=min(a,Mx2-1);
					a=max(a,0);
					b=coucou.y - pasY;
					b=min(b,My2-1);
					b=max(b,0);
                    // 
					knn_attempt_n(m[i2], i, j, a, b, pos,
                            image3d1, image3d2,
                            good1, good2);
					// m[i2].insert2(d, a-i, b-j);
				}
			}
			
            
//             for (int ii = 0; ii < k; ii++) {
//                 m4.mat[ii]=m[i2].mat[ii]; 
// 			}
//             // k normalement puisque c'est toujours plein :
//             m4.nbElements = m[i2].nbElements;

            // Random search
			for(l=0;l<k;l++){
				coucou = m[i2].mat[l];
//                 coucou = m4.mat[l];
				a=coucou.x;
				b=coucou.y;
				semiSize2=(double)maxi0;
				while(semiSize2>1){
					g=(int) ceil(semiSize2);
					minX=max(a-g,0);
					minY=max(b-g,0);
					maxX=min(a+g,Mx2-1);
					maxY=min(b+g,My2-1);
					xrand=randBetween(minX, maxX);
					yrand=randBetween(minY, maxY);
                    knn_attempt_n(m[i2], i, j, xrand, yrand, pos,
                            image3d1, image3d2,
                            good1, good2);
					semiSize2=semiSize2*alpha;
				}
			}
            
//             for (int ii = 0; ii < k; ii++) {
//                 m[i2].mat[ii]=m4.mat[ii]; 
// 			}
//             // k normalement puisque c'est toujours plein :
//             m[i2].nbElements = m4.nbElements;

		}
	}
    mexPrintf("End of step %d.\n\n", iStep);
    mexEvalString("drawnow;");
}




////////////////////////////////////////
// Output :
// x_mat (Mx*My*k)
// y_mat (Mx*My*k)
// d_mat (Mx*My*k)
////////////////////////////////////////

//mxCreateDoubleMatrix(dimy,dimx,mxREAL);
//mxArray *mxCreateNumericArray(mwSize ndim, const mwSize *dims, 
         //mxClassID classid, mxComplexity ComplexFlag);
mwSize dims3[3]={Mx1,My1,k}; // int = mwSize?
mxArray *x_mat1 = plhs[0] = mxCreateNumericArray(3,dims3,mxINT32_CLASS,mxREAL);
mxArray *y_mat1 = plhs[1] = mxCreateNumericArray(3,dims3,mxINT32_CLASS,mxREAL);
mxArray *d_mat1 = plhs[2] = mxCreateNumericArray(3,dims3,mxDOUBLE_CLASS,mxREAL);



////////////////////////////
// Output
///////////////////////////

int *x_mat = (int *) mxGetData(x_mat1);
int *y_mat = (int *) mxGetData(y_mat1);
double *d_mat = mxGetPr(d_mat1); //(double *) mxGetData

for(i=0; i<Mx1; i++){//l
	for(j=0; j<My1; j++){
		i2 = i + j*Mx1;
		for(l=0; l<k; l++){
			i3 = i2 + l*Mx1*My1;
			coucou = m[i2].mat[l];
			d_mat[i3] = coucou.d;
			x_mat[i3] = coucou.x;
			y_mat[i3] = coucou.y;
		}
	}
}

mxFree(m3);
mxFree(m2);
mxFree(m);

mexPrintf("End of patch match.\n");

return;
}


