// -----------------
// Inputs :
// imageToComplete=[1 2 3;4 5 6]; = image1
// imageUsed=ones(4); = image2
// nbEtapes=5;
// k=2;
// mask (par exemple continuous) qui remplacera largeurFenetre en donnant plus d'information
//        ---> Attention la somme de mask doit obligatoirement etre egale a 1 (densite de probabilitÃ©)
// good3 --> known in image1
// good4 --> known in image2.
// good2 --> target (fullyKnown in image2)
   // you need to do good2=fullyKnown([1+semiSize:Mx-semiSize],[1+semiSize:My-semiSize]);
   // dans matlab avant de le mettre en entrée.
// -----------------
// Outputs :
// x_mat (Mx*My*k)
// y_mat (Mx*My*k)
// d_mat (Mx*My*k)
//////////////////////
// [x,y,d]=pm2(b,c,nbEtapes,k,mask,good3,good4, good2);
/////////////////////

#include <mex.h>
#include "matrix.h"
#include <cstdio>
#include <cstdlib>
#include <ctime>
#include <algorithm>
#include <math.h>

//#define K_MAX 10
//#define NB_STEPS 5


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
  
  PositionSet() {
  }

  void init(int nhash_) {
    for (int i = 0; i < NHASH; i++) { item[i] = NULL; }
    for (int i = 0; i < NHASH-1; i++) { item_data[i].next = &item_data[i+1]; }
    item_data[NHASH-1].next = NULL;
    free_item = &item_data[0];
  }
  
  PositionSet(int nhash_) {
    init(nhash_);
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

class XyCoord{
public:
	double d;
	int x;
	int y;
};



////////////////////////////////////////////////
// MaxHeap comes from
//  http://www.codeproject.com/Tips/816934/Min-Binary-Heap-Implementation-in-Cplusplus
// by Anton Kaminsky
// template <class key, class value>
//template <unsigned int k0>
class MaxHeap
{
public:

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

MaxHeap(int k){
	nbElements=0;
	//mat = (XyCoord*) mxMalloc(sizeof(XyCoord)*k);
	mat = (XyCoord*)mxCalloc(k, sizeof(XyCoord));
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
double getDist_old(Mat3d &image3d1, Mat3d &image3d2, int i, int j, int a, int b, int sizePatch,
				   Mat3d &good3, Mat3d &good4, Mat3d &mask){
	double temp, d=0, d0=0, coeff;
	int n, dx, dy;
	double sum=0;
	
	for(dx=0; dx<sizePatch; dx++){
	for(dy=0; dy<sizePatch; dy++){
		d0=0;
		for(n=0; n < image3d1.Mz; n++){
			temp = image3d1.getNb(i+dx,j+dy,n) -
				   image3d2.getNb(a+dx,b+dy,n);
			d0 += temp*temp;
		}
		coeff = good3.getNb(i+dx,j+dy,0) * good4.getNb(a+dx,b+dy,0) * mask.getNb(dx,dy,0);
		sum+=coeff;
		d+=d0*coeff;
	}}
	
	if(sum<0.1){
		d=1e10; // not enough pixels known --> big distance
	}else{
		d=d/sum;
	}
	
	return d;
}



// with possibility of early termination
// We really need here to have sum(mask(:))=1

// double getDist(Mat3d &image3d1, Mat3d &image3d2, int i, int j, int a, int b, int sizePatch, double distMax,
// 			   Mat3d &good3, Mat3d &good4, Mat3d &mask){
// 	double temp, d=0, d0=0, coeff;
// 	int n, dx, dy;
// 	double sum=0;
// 	
// 	for(dx=0; dx<sizePatch; dx++){
// 	for(dy=0; dy<sizePatch; dy++){
// 		d0=0;
// 		for(n=0; n < image3d1.Mz; n++){
// 			temp = image3d1.getNb(i+dx,j+dy,n) -
// 				   image3d2.getNb(a+dx,b+dy,n);
// 			d0 += temp*temp;
// 		}
// 		coeff = good3.getNb(i+dx,j+dy,0) * good4.getNb(a+dx,b+dy,0) * mask.getNb(dx,dy,0);
// 		sum+=coeff;
// 		d+=d0*coeff;
// 		if (d > distMax) { return d; } // early termination to go faster
// 		// it's possible because dividing by sum at the end, only augments d.
// 		// But we need sum(d(:))=1 for this to be true
// 	}}
// 	
// 	if(sum<0.1){
// 		d=1e10; // not enough pixels known --> big distance
// 	}else{
// 		d=d/sum;
// 	}
// 
// 	return d;
// }


int randBetween(int a, int b){
	return a+(rand()%(b-a+1));
}


void knn_attempt_n(MaxHeap * m, int i2, int i, int j, 
        int a, int b, PositionSet &pos0, Mat3d &image3d1,
        Mat3d &image3d2, int sizePatch, Mat3d &good3,
        Mat3d &good4, Mat3d &mask, Mat3d &good2){
	//int deltaX = a-i;
	//int deltaY = b-j;
	if(pos0.contains(a, b)|| 
      (good2.getNb(a,b,0) < 0.5) //&& (good1.getNb(i,j,0) > 0.5)
   ){
		return;
	}
	
	double distMax = m[i2].mat[0].d;
	double d=getDist_old(image3d1, image3d2, i, j, a, b,
            sizePatch, good3, good4, mask);
			
	if(d < m[i2].mat[0].d){
		pos0.remove(m[i2].mat[0].x, m[i2].mat[0].y);
		m[i2].DeleteMax();
		m[i2].insert(d, a, b);
		pos0.insert_nonexistent(a, b);
	}
}






/////////////////////////////////////////
// Main function
/////////////////////////////////////////
// [x,y,d]=pm2(b,c,nbEtapes,k,mask,good3,good4, good2);
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

mexPrintf("Begin of patch match.\n\n");
mexEvalString("drawnow;");

// On initialise les nombres aleatoires
srand((unsigned int)time(NULL));
	
double alpha=0.5;
int a,b;
double d;
int i, j, l, n;

double temp;

double * k_mat = mxGetPr(prhs[3]);
int k = (int)k_mat[0];
double * nbSteps_mat = mxGetPr(prhs[2]);
int nbSteps = (int)nbSteps_mat[0];
// double * sizePatch_mat = mxGetPr(prhs[4]);
// int sizePatch = (int)sizePatch_mat[0];


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

Mat3d mask(prhs[4]);
int sizePatch = mask.Mx;

Mat3d good3(prhs[5]);
Mat3d good4(prhs[6]);
Mat3d good2(prhs[7]);

//MaxHeap<k> m[Mx*My];
int Mx3 = Mx1-sizePatch+1;
int My3 = My1-sizePatch+1;
int Mx4 = Mx2-sizePatch+1;
int My4 = My2-sizePatch+1;

//MaxHeap<K_MAX> * m = (MaxHeap<K_MAX>*)mxCalloc(Mx3*My3,sizeof(MaxHeap<K_MAX>));
MaxHeap * m = (MaxHeap*)mxCalloc(Mx3*My3,sizeof(MaxHeap));
XyCoord * m2 = (XyCoord *)mxCalloc(Mx3*My3*k,sizeof(XyCoord));

int i2=0;
for(j=0; j<My3; j++){//l
	for(i=0; i<Mx3; i++){
		//i2 = i + j*Mx3;
        m[i2].mat=&(m2[i2*k]);
        m[i2].nbElements=0;
		//m[i2]=MaxHeap(k);
		//m[i2].mat=mxCalloc(...)
        i2++;
	}
}


for(j=0; j<My3; j++){
	for(i=0; i<Mx3; i++){
		PositionSet chosen(k);
		for(l=0; l<k; l++){
			while(1){
				a = rand() % Mx4;
				b = rand() % Mx4;
				if (chosen.try_insert(a, b)&&
                   (
                        (good2.getNb(a,b,0) > 0.5) 
                        //||(good1.getNb(i,j,0) < 0.5)
                    )) {
					// d = getDist(image3d1, image3d2, i, j, a, b, sizePatch, INT_MAX);
					d = getDist_old(image3d1, image3d2, i, j, a, b, sizePatch, good3, good4, mask);
					m[i+Mx3*j].insert(d, a, b);
					break;
				}
			}
		}
	}
}


/////////////////////////////////////////
// Algorithm
int i3=0;
XyCoord coucou;
int maxi0 = max(Mx4,My4);
int iStep, pas, debutX, debutY, finX, finY, xORy, pasX, pasY;
double semiSize2;
int g;
int minX, minY, maxX, maxY;
int xrand, yrand;
PositionSet pos(k);

for(iStep=1;iStep<=nbSteps;iStep++){ //
    mexPrintf("Begin of step %d.\n", iStep);
    
	if(iStep%2){
		pas=1;
		debutX=1;
		debutY=1;
		finX=Mx3-1;
		finY=My3-1;
	}else{
		pas=-1;
		finX=0;
		finY=0;
		debutX=Mx3-2;
		debutY=My3-2;
	}
	
	for(i=debutX; i!=(finX+pas); i+=pas){
		for(j=debutY; j!=(finY+pas); j+=pas){
			i2=i+Mx3*j;
			
			pos.init(k);
			for (int ii = 0; ii < k; ii++) {
				pos.insert_nonexistent(m[i2].mat[ii].x, m[i2].mat[ii].y);
			}
			
			// Propagation
			for(xORy=0; xORy<=1; xORy++){
				pasX = (-pas)*xORy;
				pasY = (-pas)*(1-xORy);
				i3 = i+pasX + Mx3*(j+pasY);
				for(l=0;l<k;l++){
					coucou = m[i3].mat[l];
					a=coucou.x - pasX;
					a=min(a,Mx4-1);
					a=max(a,0);
					b=coucou.y - pasY;
					b=min(b,My4-1);
					b=max(b,0);
					knn_attempt_n(m, i2, i, j, a, b, pos, image3d1, 
					              image3d2, sizePatch, good3,
                                  good4, mask, good2);
					// m[i2].insert2(d, a-i, b-j);
				}
			}
			
			// Random search
			for(l=0;l<k;l++){
				coucou = m[i2].mat[l];
				a=coucou.x;
				b=coucou.y;
				semiSize2=(double)maxi0;
				while(semiSize2>1){
					g=(int) ceil(semiSize2);
					minX=max(a-g,0);
					minY=max(b-g,0);
					maxX=min(a+g,Mx4-1);
					maxY=min(b+g,My4-1);
					xrand=randBetween(minX, maxX);
					yrand=randBetween(minY, maxY);
					knn_attempt_n(m, i2, i, j, xrand, yrand, pos, image3d1,
					              image3d2, sizePatch, good3, 
                                  good4, mask, good2);
					semiSize2=semiSize2*alpha;
				}
			}
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
mwSize dims3[3]={Mx3,My3,k}; // int = mwSize?
mxArray *x_mat1 = plhs[0] = mxCreateNumericArray(3,dims3,mxINT32_CLASS,mxREAL);
mxArray *y_mat1 = plhs[1] = mxCreateNumericArray(3,dims3,mxINT32_CLASS,mxREAL);
mxArray *d_mat1 = plhs[2] = mxCreateNumericArray(3,dims3,mxDOUBLE_CLASS,mxREAL);



////////////////////////////
// Output
///////////////////////////

int *x_mat = (int *) mxGetData(x_mat1);
int *y_mat = (int *) mxGetData(y_mat1);
double *d_mat = mxGetPr(d_mat1); //(double *) mxGetData

i2=0;
i3=0;
for(j=0; j<My3; j++){//l
	for(i=0; i<Mx3; i++){
		//i2 = i + j*Mx3;
		for(l=0; l<k; l++){
			i3 = i2 + l*Mx3*My3;
			coucou = m[i2].mat[l];
			d_mat[i3] = coucou.d;
			x_mat[i3] = coucou.x;
			y_mat[i3] = coucou.y;
		}
		//mxFree(m[i2].mat);
        i2++;
	}
    //i2+=Mx3;
}

mxFree(m2);
mxFree(m);

mexPrintf("End of patch match.\n");

return;
}








