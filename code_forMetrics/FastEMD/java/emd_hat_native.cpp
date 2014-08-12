#include "emd_hat_native.hpp"
#include <vector>
#include "emd_hat.hpp"

JNIEXPORT jdouble JNICALL Java_emd_1hat_native_1dist_1compute
(JNIEnv *env, jclass jc,
 jdoubleArray P_j, jdoubleArray Q_j, jdoubleArray Cv_j, jdouble extra_mass_penalty_j,
 jdoubleArray Fv_j,
 jint N_j, jint gd_metric_j, jint Fv_j_is_null_j) {

    int N= N_j;
    int gd_metric= gd_metric_j;
    int Fv_j_is_null= Fv_j_is_null_j;

    
    
    
    jdouble* P_j_e= env->GetDoubleArrayElements(P_j,NULL);
    std::vector<double> P(P_j_e,P_j_e+N);
    env->ReleaseDoubleArrayElements(P_j, P_j_e, JNI_ABORT);

    jdouble* Q_j_e= env->GetDoubleArrayElements(Q_j,NULL);
    std::vector<double> Q(Q_j_e,Q_j_e+N);
    env->ReleaseDoubleArrayElements(Q_j, Q_j_e, JNI_ABORT);

    jdouble* C_j_e= env->GetDoubleArrayElements(Cv_j,NULL);
    std::vector<double> Cvector(C_j_e,C_j_e+N*N);
    env->ReleaseDoubleArrayElements(Cv_j, C_j_e, JNI_ABORT);
        
    std::vector< std::vector<double> > C(N, std::vector<double>(N));
    int Cvector_i= 0;
    for (int i= 0; i<N; ++i) {
        for (int j= 0; j<N; ++j) {
            C[i][j]= Cvector[Cvector_i];
            ++Cvector_i;
        }
    }
        
    double extra_mass_penalty= extra_mass_penalty_j;
    
    std::vector< std::vector<double> >* Fp= NULL;
    if (!Fv_j_is_null) Fp= new std::vector< std::vector<double> >(N, std::vector<double>(N));

    double dist= -1;
    if (gd_metric) {
        if (Fp) {
            dist= emd_hat_gd_metric<double,WITHOUT_EXTRA_MASS_FLOW>()(P,Q,C,extra_mass_penalty,Fp);
        } else {
            dist= emd_hat_gd_metric<double,NO_FLOW>()(P,Q,C,extra_mass_penalty,Fp);
        }
    } else {
        if (Fp) {
            dist= emd_hat<double,WITHOUT_EXTRA_MASS_FLOW>()(P,Q,C,extra_mass_penalty,Fp);
        } else {
            dist= emd_hat<double,NO_FLOW>()(P,Q,C,extra_mass_penalty,Fp);
        }
    }
    assert(dist!=-1);
        
    // convert Fp to regular F
    if (Fp) {
        jboolean isCopy = JNI_FALSE;
        jdouble *Fv_j_e = env->GetDoubleArrayElements(Fv_j, &isCopy);
        int Fv_j_e_i= 0;
        for (int i= 0; i<N; ++i) {
            for (int j= 0; j<N; ++j) {
                Fv_j_e[Fv_j_e_i]= (*Fp)[i][j];
                ++Fv_j_e_i;
            }
        }
        // The third argument here should be 0, so that content will change
        // on original array.
        env->ReleaseDoubleArrayElements(Fv_j, Fv_j_e, 0);
    }

    return dist;
    
    delete Fp;
}





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
