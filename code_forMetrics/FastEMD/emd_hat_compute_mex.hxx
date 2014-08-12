#ifndef EMD_HAT_COMPUTE_MEX_HXX_
#define EMD_HAT_COMPUTE_MEX_HXX_

#include "mex.h"
#include "emd_hat.hpp"
#include <vector>

template<typename NUM_T>
void emd_hat_compute_mex_impl(int nout, mxArray *out[], int nin, const mxArray *in[], bool gd_metric,mxClassID classID);
    
void emd_hat_compute_mex(int nout, mxArray *out[], int nin, const mxArray *in[], bool gd_metric) {

    switch (mxGetClassID(in[0])) {
        
    case mxINT32_CLASS:
        assert(size(int)==4); // TODO: static assert
        emd_hat_compute_mex_impl<int>(nout,out,nin,in,gd_metric,mxGetClassID(in[0]));
        break;

    case mxINT64_CLASS:
        assert(size(long long int)==8); // TODO: static assert
        emd_hat_compute_mex_impl<long long int>(nout,out,nin,in,gd_metric,mxGetClassID(in[0]));
        break;

    case mxDOUBLE_CLASS:
        emd_hat_compute_mex_impl<double>(nout,out,nin,in,gd_metric,mxGetClassID(in[0]));
        break;

    default:
        mexErrMsgTxt("Support only int32, int64 and double types");
        break;
    }

} // emd_hat_compute_mex
        

template<typename NUM_T>
void emd_hat_compute_mex_impl(int nout, mxArray *out[], int nin, const mxArray *in[], bool gd_metric,mxClassID classID) {

    std::vector<NUM_T> Pv;
    std::vector<NUM_T> Qv;
    std::vector< std::vector<NUM_T> > Cv;
    std::vector< std::vector<NUM_T> > Fv;
    std::vector< std::vector<NUM_T> >* F;
    NUM_T extra_mass_penalty;
    FLOW_TYPE_T FLOW_TYPE= NO_FLOW;
        
    const NUM_T* P= static_cast<const NUM_T*>( mxGetData(in[0]) );
    const NUM_T* Q= static_cast<const NUM_T*>( mxGetData(in[1]) );
    const NUM_T* C= static_cast<const NUM_T*>( mxGetData(in[2]) );
    unsigned int N= static_cast<unsigned int>(mxGetM(in[0]));
    // Check that C is non-negative
    for (unsigned int i=0; i<N; ++i) {
        for (unsigned int j=0; j<N; ++j) {
            if ( C[i*N+j]<0) {
                mexErrMsgTxt("There is a negative cost edge");
            }
        }
    }
    Pv.insert(Pv.end(),P,P+N);
    Qv.insert(Qv.end(),Q,Q+N);
    Cv= std::vector< std::vector<NUM_T> >( N,std::vector<NUM_T>(N) );
    {for (unsigned int i=0; i<N; ++i) {
        {for (unsigned int j=0; j<N; ++j) {
            Cv[i][j]= C[i+j*N];
        }}
    }}
    extra_mass_penalty= -1;
    if (nin>=4) {
        const NUM_T* extra_mass_penalty_ptr= static_cast<const NUM_T*>( mxGetData(in[3]) );
        extra_mass_penalty= *extra_mass_penalty_ptr;
    }
    if (nout>1) {
        Fv= std::vector< std::vector<NUM_T> >( N,std::vector<NUM_T>(N) );
        F= &Fv;
        FLOW_TYPE= WITHOUT_TRANSHIPMENT_FLOW;
        if (nin==5) {
            const NUM_T* FType_ptr= static_cast<const NUM_T*>( mxGetData(in[4]) );
            int FType= static_cast<int>(*FType_ptr);
            switch (FType) {
            case 2:
                FLOW_TYPE= WITHOUT_TRANSHIPMENT_FLOW;
                break;
            case 3:
                FLOW_TYPE= WITHOUT_EXTRA_MASS_FLOW;
                break;
            default:
                mexErrMsgTxt("FType should be either 2/3 when you request the flow F");
                break;
            }
        }
    } else {
        F= NULL;
        if (nin==5) {
            const NUM_T* FType_ptr= static_cast<const NUM_T*>( mxGetData(in[4]) );
            int FType= static_cast<int>(*FType_ptr);
            switch (FType) {
            case 1:
                FLOW_TYPE= NO_FLOW;
                break;
            default:
                mexErrMsgTxt("FType should be 1 when you don't request the flow F");
                break;
            }
        }
    }
    
    NUM_T dist;
    //-------------------------------------------------------

    switch (FLOW_TYPE) {
    case NO_FLOW:
        if (gd_metric) {
            dist= emd_hat_gd_metric<NUM_T,NO_FLOW>()(Pv,Qv,Cv, extra_mass_penalty, F);
        } else {
            dist= emd_hat<NUM_T,NO_FLOW>()(Pv,Qv,Cv, extra_mass_penalty, F);
        }
        break;
    case WITHOUT_TRANSHIPMENT_FLOW:
        if (gd_metric) {
            dist= emd_hat_gd_metric<NUM_T,WITHOUT_TRANSHIPMENT_FLOW>()(Pv,Qv,Cv, extra_mass_penalty, F);
        } else {
            dist= emd_hat<NUM_T,WITHOUT_TRANSHIPMENT_FLOW>()(Pv,Qv,Cv, extra_mass_penalty, F);
        }
        break;
    case WITHOUT_EXTRA_MASS_FLOW:
        if (gd_metric) {
            dist= emd_hat_gd_metric<NUM_T,WITHOUT_EXTRA_MASS_FLOW>()(Pv,Qv,Cv, extra_mass_penalty, F);
        } else {
            dist= emd_hat<NUM_T,WITHOUT_EXTRA_MASS_FLOW>()(Pv,Qv,Cv, extra_mass_penalty, F);
        }
        break;
    }
    
    
    int dims[]= {1};
    out[0]= mxCreateNumericArray(1, dims, classID, mxREAL);
    NUM_T* distPtr= (NUM_T*)mxGetData(out[0]);
    *distPtr= dist;

    if (nout>1) {
        int Fdims[2];
        Fdims[0]= N;
        Fdims[1]= N;
        out[1]= mxCreateNumericArray(2, Fdims, classID, mxREAL);
        NUM_T* Fptr= (NUM_T*)mxGetData(out[1]);
        for (unsigned int i= 0; i<N; ++i) {
            for (unsigned int j= 0; j<N; ++j) {
                *Fptr= Fv[j][i];
                ++Fptr;
            }
        }
    }
    
} // emd_hat_compute_mex_impl

#endif 
    
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
