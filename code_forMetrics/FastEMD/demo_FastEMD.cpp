#include "emd_hat.hpp"
#include "emd_hat_signatures_interface.hpp"
#include "tictoc.hpp"
#include <vector>
#include <iostream>
#include <fstream>
#include <stdlib.h>
#ifdef COMPUTE_RUBNER_VERSION
#include "rubner_emd/emd.h"
#endif

std::vector< std::vector<int> > cost_mat; // for emd_hat version, defined globally only because of Rubner's version
#ifdef COMPUTE_RUBNER_VERSION
float cost_mat_dist(feature_t *F1, feature_t *F2) { return cost_mat[*F1][*F2]; } // for Rubner's version
#endif
int cost_mat_dist_int(feature_tt *F1, feature_tt *F2) { return cost_mat[*F1][*F2]; } // for emd_hat_signatures_interface

//--------------------------------------------------------------------------------------------
// Read images of the format:
// im_rows_num im_columns_num
// im_pixels ...
void readImage(const char* im_name,
               unsigned int& im_R,
               unsigned int& im_C,
               std::vector<int>& im) {
    
    std::fstream fin(im_name);
    if (!fin) goto readImageErrLabel;
    
    fin >> im_R;
    if (!fin) goto readImageErrLabel;
    fin >> im_C;
    if (!fin) goto readImageErrLabel;
    
    int tmp;
    while (fin >> tmp) {
        im.push_back(tmp);
    }
    
    if (im.size()==im_R*im_C) return;
readImageErrLabel:
    std::cerr << "Image " << im_name << " has a problem in its format" << std::endl;
    exit(1);
    
} // readImage
//--------------------------------------------------------------------------------------------




int main( int argc, char* argv[]) {

    //-----------------------------------------------
    // Read images
    const char* im1_name= "cameraman.txt";
    const char* im2_name= "rice.txt";
    unsigned int im1_R, im1_C, im2_R, im2_C;
    std::vector<int> im1,im2;
    readImage(im1_name, im1_R, im1_C, im1);
    readImage(im2_name, im2_R, im2_C, im2);
    if ( (im1_R!=im2_R) || (im1_C!=im2_C) ) {
        std::cerr << "Images should be of the same size" << std::endl;
    }
    //-----------------------------------------------

    
    //-----------------------------------------------
    // The ground distance - thresholded Euclidean distance.
    // Since everything is ints, we multiply by COST_MULT_FACTOR.
    const int COST_MULT_FACTOR= 1000;
    const int THRESHOLD= 3*COST_MULT_FACTOR;//1.412*COST_MULT_FACTOR;
    // std::vector< std::vector<int> > cost_mat; // here it's defined as global for Rubner's interfaces.
                                                   // If you do not use Rubner's interface it's a better idea
                                                   // not to use globals.
    std::vector<int> cost_mat_row(im1_R*im1_C);
    for (unsigned int i=0; i<im1_R*im1_C; ++i) cost_mat.push_back(cost_mat_row);
    int max_cost_mat= -1;
    int j= -1;
    for (unsigned int c1=0; c1<im1_C; ++c1) {
        for (unsigned int r1=0; r1<im1_R; ++r1) {
            ++j;
            int i= -1;
            for (unsigned int c2=0; c2<im1_C; ++c2) {
                for (unsigned int r2=0; r2<im1_R; ++r2) {
                    ++i;
                    cost_mat[i][j]= std::min(THRESHOLD,static_cast<int>(COST_MULT_FACTOR*sqrt((r1-r2)*(r1-r2)+(c1-c2)*(c1-c2))));
                    if (cost_mat[i][j]>max_cost_mat) max_cost_mat= cost_mat[i][j];
                }
            }
		}
	}
    //-----------------------------------------------
    
    
    //-----------------------------------------------
    // Convert to Rubner's version
    //-----------------------------------------------
    #ifdef COMPUTE_RUBNER_VERSION
    signature_t Psig;
    signature_t Qsig;
    Psig.n= im1_R*im1_C;
    Qsig.n= im1_R*im1_C;
    Psig.Features= new feature_t[im1_R*im1_C];
    Qsig.Features= new feature_t[im1_R*im1_C];
    {for (unsigned int i=0; i<im1_R*im1_C; ++i) {
        Psig.Features[i]= i;
        Qsig.Features[i]= i;
    }}
    Psig.Weights= new float[im1_R*im1_C];
    Qsig.Weights= new float[im1_R*im1_C];
    {for (unsigned int i=0; i<im1_R*im1_C; ++i) {
        Psig.Weights[i]= im1[i];
        Qsig.Weights[i]= im2[i];
    }}
    #endif
    //-----------------------------------------------

    //-----------------------------------------------
    // Convert to FastEMD with Rubner's interface
    //-----------------------------------------------
    signature_tt<int> Psig2;
    signature_tt<int> Qsig2;
    Psig2.n= im1_R*im1_C;
    Qsig2.n= im1_R*im1_C;
    Psig2.Features= new feature_tt[im1_R*im1_C];
    Qsig2.Features= new feature_tt[im1_R*im1_C];
    {for (unsigned int i=0; i<im1_R*im1_C; ++i) {
        Psig2.Features[i]= i;
        Qsig2.Features[i]= i;
    }}
    Psig2.Weights= new int[im1_R*im1_C];
    Qsig2.Weights= new int[im1_R*im1_C];
    {for (unsigned int i=0; i<im1_R*im1_C; ++i) {
        Psig2.Weights[i]= im1[i];
        Qsig2.Weights[i]= im2[i];
    }}
    //-----------------------------------------------
    
    tictoc timer;
    timer.tic();
    int emd_hat_gd_metric_val= emd_hat_gd_metric<int>()(im1,im2, cost_mat,THRESHOLD);
    timer.toc();
    std::cout << "emd_hat_gd_metric time in seconds: " << timer.totalTimeSec() << std::endl;

    timer.clear();
    timer.tic();
    int emd_hat_val= emd_hat<int>()(im1,im2, cost_mat,THRESHOLD);
    timer.toc();
    std::cout << "emd_hat time in seconds: " << timer.totalTimeSec() << std::endl;

    timer.clear();
    timer.tic();
    int emd_hat_signatures_interface_val= emd_hat_signature_interface<int>(&Psig2, &Qsig2, cost_mat_dist_int,-1);
    timer.toc();
    std::cout << "emd_hat_signatures_interface time in seconds: " << timer.totalTimeSec() << std::endl;

    #ifdef COMPUTE_RUBNER_VERSION
    timer.clear();
    timer.tic();
    int sumBig= 0;
    int sumSmall= 0;
    {for (unsigned int i=0; i<im1.size(); ++i) {
        sumBig+= im1[i];
        sumSmall+= im2[i];
    }}
    if (sumSmall>sumBig) {
        std::swap(sumSmall,sumBig);
    }
    int emd_rubner_val= static_cast<int>((sumSmall*emd(&Psig, &Qsig, cost_mat_dist, NULL, NULL)) +
                                             (sumBig-sumSmall)*max_cost_mat);
    timer.toc();
    std::cout << "emd_rubner time in seconds: " << timer.totalTimeSec() << std::endl;
    #endif
    
    #ifdef COMPUTE_RUBNER_VERSION
    delete[] Psig.Features;
    delete[] Qsig.Features;
    delete[] Psig.Weights;
    delete[] Qsig.Weights;
    #endif
    delete[] Psig2.Features;
    delete[] Qsig2.Features;
    delete[] Psig2.Weights;
    delete[] Qsig2.Weights;

    if (emd_hat_gd_metric_val!=emd_hat_val||
        emd_hat_gd_metric_val!=emd_hat_signatures_interface_val
        #ifdef COMPUTE_RUBNER_VERSION
        || emd_hat_gd_metric_val!=emd_rubner_val
        #endif
        ) {
        std::cerr << "EMDs that were computed with different interfaces are different!" << std::endl;
        std::cerr << "emd_hat_gd_metric_val==" << emd_hat_gd_metric_val << std::endl;
        std::cerr << "emd_hat_val==" << emd_hat_val << std::endl;
        std::cerr << "emd_hat_signatures_interface_val==" << emd_hat_signatures_interface_val << std::endl;
        #ifdef COMPUTE_RUBNER_VERSION
        std::cerr << "emd_rubner_val==" << emd_rubner_val << std::endl;
        #endif
        return 1;
    }
} // end main
    
    
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

