#ifndef DELTA_E_2000_HPP_
#define DELTA_E_2000_HPP_

#include <math.h>

/// Computes the CIEDE2000 color-difference between two Lab colors
/// Based on the article:
/// The CIEDE2000 Color-Difference Formula: Implementation Notes, 
/// Supplementary Test Data, and Mathematical Observations,", G. Sharma, 
/// W. Wu, E. N. Dalal, submitted to Color Research and Application, 
/// January 2004.
/// Available at http://www.ece.rochester.edu/~/gsharma/ciede2000/
/// C++ implementation by Ofir Pele, The Hebrew University of Jerusalem 2010.
class deltaE2000 {

    const double _kL,_kC,_kH;
    const double pi;
    
public:

    ///-----------------------------------------------------------
    /// Constructor
    ///-----------------------------------------------------------
    deltaE2000(double kL= 1.0, double kC= 1.0, double kH= 1.0)
        : _kL(kL), _kC(kC), _kH(kH), pi(3.141592653589793238462643383279) {}
    ///-----------------------------------------------------------

    ///-----------------------------------------------------------
    /// Computes the color-difference
    ///-----------------------------------------------------------
    double operator()(double Lstd, double astd, double bstd,
                      double Lsample, double asample, double bsample) {


        double Cabstd= sqrt(astd*astd+bstd*bstd);
        double Cabsample= sqrt(asample*asample+bsample*bsample);
        
        double Cabarithmean= (Cabstd + Cabsample)/2.0;

        double G= 0.5*( 1.0 - sqrt( pow(Cabarithmean,7.0)/(pow(Cabarithmean,7.0) + pow(25.0,7.0))));
        
        double apstd= (1.0+G)*astd; // aprime in paper
        double apsample= (1.0+G)*asample; // aprime in paper
        double Cpsample= sqrt(apsample*apsample+bsample*bsample);
        
        double Cpstd= sqrt(apstd*apstd+bstd*bstd);
        // Compute product of chromas
        double Cpprod= (Cpsample*Cpstd);


        
        // Ensure hue is between 0 and 2pi
        double hpstd= atan2(bstd,apstd);
        if (hpstd<0) hpstd+= 2.0*pi;  // rollover ones that come -ve

        double hpsample= atan2(bsample,apsample);
        if (hpsample<0) hpsample+= 2.0*pi;
        if ( (fabs(apsample)+fabs(bsample))==0.0)  hpsample= 0.0;

        double dL= (Lsample-Lstd);
        double dC= (Cpsample-Cpstd);

        // Computation of hue difference
        double dhp= (hpsample-hpstd);
        if (dhp>pi)  dhp-= 2.0*pi;
        if (dhp<-pi) dhp+= 2.0*pi;
        // set chroma difference to zero if the product of chromas is zero
        if (Cpprod == 0.0) dhp= 0.0;

        // Note that the defining equations actually need
        // signed Hue and chroma differences which is different
        // from prior color difference formulae

        double dH= 2.0*sqrt(Cpprod)*sin(dhp/2.0);
        //%dH2 = 4*Cpprod.*(sin(dhp/2)).^2;

        // weighting functions
        double Lp= (Lsample+Lstd)/2.0;
        double Cp= (Cpstd+Cpsample)/2.0;

        // Average Hue Computation
        // This is equivalent to that in the paper but simpler programmatically.
        // Note average hue is computed in radians and converted to degrees only 
        // where needed
        double hp= (hpstd+hpsample)/2.0;
        // Identify positions for which abs hue diff exceeds 180 degrees 
        if ( fabs(hpstd-hpsample)  > pi ) hp-= pi;
        // rollover ones that come -ve
        if (hp<0) hp+= 2.0*pi;

        // Check if one of the chroma values is zero, in which case set 
        // mean hue to the sum which is equivalent to other value
        if (Cpprod==0.0) hp= hpsample+hpstd;
        
        double Lpm502= (Lp-50.0)*(Lp-50.0);;
        double Sl= 1.0+0.015*Lpm502/sqrt(20.0+Lpm502);  
        double Sc= 1.0+0.045*Cp;
        double T= 1.0 - 0.17*cos(hp - pi/6.0) + 0.24*cos(2.0*hp) + 0.32*cos(3.0*hp+pi/30.0) - 0.20*cos(4.0*hp-63.0*pi/180.0);
        double Sh= 1.0 + 0.015*Cp*T;
        double delthetarad= (30.0*pi/180.0)*exp(- pow(( (180.0/pi*hp-275.0)/25.0),2.0));
        double Rc=  2.0*sqrt(pow(Cp,7.0)/(pow(Cp,7.0) + pow(25.0,7.0)));
        double RT= -sin(2.0*delthetarad)*Rc;
        
        // The CIE 00 color difference
        double dist= sqrt( pow((dL/Sl),2.0) + pow((dC/Sc),2.0) + pow((dH/Sh),2.0) + RT*(dC/Sc)*(dH/Sh) );

        return dist;
        
    } // end operator()






};

#endif

// THE HEBREW UNIVERSITY OF JERUSALEM MAKES NO REPRESENTATIONS OR WARRANTIES OF
// ANY KIND CONCERNING THIS SOFTWARE.

// IN NO EVENT SHALL THE HEBREW UNIVERSITY OF JERUSALEM BE LIABLE TO ANY PARTY FOR
// DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST
// PROFITS, ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF
// THE THE HEBREW UNIVERSITY OF JERUSALEM HAS BEEN ADVISED OF THE POSSIBILITY OF
// SUCH DAMAGE. THE HEBREW UNIVERSITY OF JERUSALEM SPECIFICALLY DISCLAIMS ANY
// WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE SOFTWARE PROVIDED
// HEREUNDER IS ON AN "AS IS" BASIS, AND THE HEBREW UNIVERSITY OF JERUSALEM HAS NO
// OBLIGATIONS TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR
// MODIFICATIONS.
