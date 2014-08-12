#include "mex.h"
#include "deltaE2000.hpp"
#include <algorithm>
#include <cassert>

#ifndef mwSize 
#define mwSize int 
#endif 
template<typename T>
const T& myMin(const T& a, const T& b) {
	if (a<b) return a;
	return b;

}

template<typename T>
const T& myMax(const T& a, const T& b) {
	if (a>b) return a;
	return b;

}


using namespace std;

//-----------------------------------------------------------------------------------------
enum COORDINATE_TRANSFORM_METHOD_TYPE {
    IDENTITY,
    CENTER,
    NORMALIZED
};
//-----------------------------------------------------------------------------------------


//-----------------------------------------------------------------------------------------
static void coordinate_transform(int x, int y, COORDINATE_TRANSFORM_METHOD_TYPE t,
                                 int xs, int ys,
                                 double& tx, double& ty) {
    // x and y should be (x-1) and (y-1) because of Matlab coordinates.
    // I assume that this function will be used for difference between coordinates,
    // so when it does not effect the results, I do not use (x-1) and (y-1).
    switch (t) {
    case IDENTITY:
        tx= x;
        ty= y;
        return;
    case CENTER:
        tx= x-((xs+1)/2.0); 
        ty= y-((ys+1)/2.0);
        return;
    case NORMALIZED:
        // Here the original is (x-1),(y-1) in Matlab coordinates in the numerator.
        // So I just use x and y.
        if (xs!=1) {
            tx= (x)/(static_cast<double>(xs)-1);
        } else {
            tx= x;
        }
        if (ys!=1) {
            ty= (y)/(static_cast<double>(ys)-1);
        } else {
            ty= y;
        }
        return;
    default:
        assert(0);
    }
    return;
} // coordinate_transform
//-----------------------------------------------------------------------------------------


//-----------------------------------------------------------------------------------------
static void inv_coordinate_transform(double tx, double ty, COORDINATE_TRANSFORM_METHOD_TYPE t,
                                     int xs, int ys,
                                     double& x, double& y) {
    // x and y should be (x-1) and (y-1) because of Matlab coordinates.
    // I assume that this function will be used for difference between coordinates,
    // so when it does not effect the results, I do not use (x-1) and (y-1).
    switch (t) {
    case IDENTITY:
        x= tx;
        y= ty;
        return;
    case CENTER:
        x= tx+((xs+1)/2.0); 
        y= ty+((ys+1)/2.0);
        return;
    case NORMALIZED:
        // Here the original is (x-1),(y-1) in Matlab coordinates in the numerator.
        // So I just use x and y.
        if (xs!=1) {
            x=tx*(static_cast<double>(xs)-1);
        } else {
            x= tx;
        }
        if (ys!=1) {
            y=ty*(static_cast<double>(ys)-1);
        } else {
            y= ty;
        }
        return;
    default:
        assert(0);
    }
    return;
} // inv_coordinate_transform
//-----------------------------------------------------------------------------------------



//-----------------------------------------------------------------------------------------
void mexFunction(int nout, mxArray *out[],
                 int nin, const mxArray *in[]) {

    //----------------------------------------------------------------------
    // extract input
    //----------------------------------------------------------------------
    const double* im1= static_cast<double*>( mxGetData(in[0]) );
    const mwSize* im1_dims= mxGetDimensions(in[0]);
    mwSize im1_ndims= mxGetNumberOfDimensions(in[0]);
    const double* im2= static_cast<double*>( mxGetData(in[1]) );
    const mwSize* im2_dims= mxGetDimensions(in[1]);
    mwSize im2_ndims= mxGetNumberOfDimensions(in[1]);

    if (im1_ndims!=3||im2_ndims!=3||im1_dims[2]!=3||im2_dims[2]!=3) {
        mexErrMsgTxt("im1 and im2 should be 3d L*a*b* images");
    }
        
    const int im1_X= im1_dims[1];
    const int im1_Y= im1_dims[0];
    const int im1_N= im1_Y*im1_X;
    const int im2_X= im2_dims[1];
    const int im2_Y= im2_dims[0];
    const int im2_N= im2_Y*im2_X;
    const int N= im1_N+im2_N;

    const double alpha_color= *( static_cast<double*>( mxGetData(in[2]) ));
    const double alpha_spatial= 1-alpha_color;

    const double threshold=  *( static_cast<double*>( mxGetData(in[3]) ));

    const double threshold_div_alpha_spatial= threshold/alpha_spatial;
    
    COORDINATE_TRANSFORM_METHOD_TYPE t;
    const double* t_ptr= static_cast<const double*>( mxGetData(in[4]) );
    int t_int= static_cast<int>(*t_ptr);
    switch (t_int) {
    case 1:
        t= IDENTITY;
        break;
    case 2:
        t= CENTER;
        break;
    case 3:
        t= NORMALIZED;
        break;
    default:
        mexErrMsgTxt("coordinates_transformation should be 1,2 or 3");
        break;
    }
    //----------------------------------------------------------------------

    
    //----------------------------------------------------------------------
    // create and fill output
    //----------------------------------------------------------------------
    // init 0 on diagonal, threshold anywhere else
    out[0]= mxCreateNumericMatrix(N,N,mxDOUBLE_CLASS,mxREAL);
    double* matPtr= (double*)mxGetData(out[0]);
    double* matPtr_t= matPtr;
    for (int i=0; i<N; ++i) {
        for (int j=0; j<N; ++j) {
            if (i!=j) {
                (*matPtr_t)= threshold;
            } else {
                (*matPtr_t)= 0.0;
            }
            ++matPtr_t;
        }
    }
   
    // ground distance matrix:
    // ---------
    // | 1 | 2 |
    // ---------
    // | 3 | 4 |
    // ---------
    // 2,3 are filled here.
    // Note: 1 and 4 are skipped as there are no arcs there in the EMD computation
    // for other distance (e.g. Quadratic Form), 1,4 computation should not be skipped!
    {int i= 0;
    for (int x1=0; x1<im1_X; ++x1) {
        for (int y1=0; y1<im1_Y; ++y1) {
                        
            double L1= im1[(y1)+((x1)+(0)*im1_X)*im1_Y];
            double a1= im1[(y1)+((x1)+(1)*im1_X)*im1_Y];
            double b1= im1[(y1)+((x1)+(2)*im1_X)*im1_Y];
            double tx1,ty1;
            coordinate_transform(x1,y1,t, im1_X,im1_Y, tx1,ty1);

            // Limiting the search on x2,y2. Since I'm currently not working
            // on sparse representation, the reduction in runtime is low.
            double d_x2b= tx1-threshold_div_alpha_spatial;
            double d_y2b= ty1-threshold_div_alpha_spatial;
            inv_coordinate_transform(d_x2b,d_y2b,t, im2_X,im2_Y, d_x2b,d_y2b);
            int x2b= myMax(0,static_cast<int>(floor(d_x2b)));
            int y2b= myMax(0,static_cast<int>(floor(d_y2b)));
            double d_x2e= tx1+threshold_div_alpha_spatial;
            double d_y2e= ty1+threshold_div_alpha_spatial;
            inv_coordinate_transform(d_x2e,d_y2e,t, im2_X,im2_Y, d_x2e,d_y2e);
            int x2e= myMin(im2_X-1,static_cast<int>(ceil(d_x2e)));
            int y2e= myMin(im2_Y-1,static_cast<int>(ceil(d_y2e)));

                        
            for (int x2=x2b; x2<=x2e; ++x2) {
                for (int y2=y2b; y2<=y2e; ++y2) {
                    
                    double L2= im2[(y2)+((x2)+(0)*im2_X)*im2_Y];
                    double a2= im2[(y2)+((x2)+(1)*im2_X)*im2_Y];
                    double b2= im2[(y2)+((x2)+(2)*im2_X)*im2_Y];
                    double tx2,ty2;
                    coordinate_transform(x2,y2,t, im2_X,im2_Y, tx2,ty2);
                    
                    double x_diff= tx1-tx2;
                    double y_diff= ty1-ty2;
                    double spatial_dist= alpha_spatial*(sqrt( (x_diff*x_diff) + (y_diff*y_diff) ));
                    
                    if (spatial_dist<threshold) {
                        double color_dist= alpha_color*deltaE2000()(L1,a1,b1, L2,a2,b2);
                        
                        double dist= color_dist + spatial_dist;
                        
                        if (dist<threshold) {
                            int j= j=x2*im2_Y+y2;
                            matPtr[i        + (im1_N+j)*(N)]= dist;
                            matPtr[(im1_N+j)+ (i)*(N)]=       dist;
                        }
                    }
                                            
                }
            }
            ++i;
        }
    }
	}

} // mexFunction
//-----------------------------------------------------------------------------------------






// Copyright (c) 2009-2012, Ofir Pele
// All rights reserved.

// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met: 
//    * Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
//    * Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
//    * Neither the name of the The Hebrew University of Jerusalem nor the
//    names of its contributors may be used to endorse or promote products
//    derived from this software without specific prior written permission.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
// IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

