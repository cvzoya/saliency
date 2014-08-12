import java.util.Random;

/**
 This demo efficiently computes the emd_hat between two 1-dimensional
 histograms where the ground distance between the bins is thresholded L_1
 emd_hat was described in the paper: <br>
   A Linear Time Histogram Metric for Improved SIFT Matching <br>
   Ofir Pele, Michael Werman <br>
   ECCV 2008 <br>
 The efficient algorithm is described in the paper: <br>
   Fast and Robust Earth Mover's Distances <br>
   Ofir Pele, Michael Werman <br>
   ICCV 2009 
 @see emd_hat
 @author Ofir Pele
*/
public class demo_FastEMD {


    public static void main(String args[]) {

        int N= 10;
        int threshold= 3;
        
        double[] P= randomDoubleArray(N);
        double[] Q= randomDoubleArray(N);

        double[][] C= new double[N][N];
        for (int i=0; i<N; ++i) {
            for (int j=0; j<N; ++j) {
                int abs_diff= Math.abs(i-j);
                C[i][j]= Math.min(abs_diff,threshold);
            }
        }
        
        double extra_mass_penalty= -1;

        double dist= emd_hat.dist_gd_metric(P,Q,C,extra_mass_penalty,null);

        System.out.print("Distance==");
        System.out.println(dist);

        /*
        // Computation with flow
        
        double[][] F= new double[N][N];

        double dist_with_flow= emd_hat.dist_gd_metric(P,Q,C,extra_mass_penalty,F);

        System.out.print("Distance==");
        System.out.println(dist_with_flow);

        System.out.println();
        System.out.println("Flow matrix: ");
        for (int i=0; i<N; ++i) {
            for (int j=0; j<N; ++j) {
                System.out.print(F[i][j]);
                System.out.print(" ");
            }
            System.out.println();
        }
        */
        
    }

    private static double[] randomDoubleArray(int N) {
        double[] randArr= new double[N];
        Random generator = new Random();
        for (int i= 0; i<N; ++i) {
            randArr[i]= generator.nextDouble();
        }
        return randArr;
    }

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
