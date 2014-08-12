#########################################################
# compiler stuff 
#########################################################
#CXX = /cs/phd/ofirpele/utils/stl_decrypt/gfilt
CXX= g++
CC= gcc
CXXFLAGS = -O -DNDEBUG 
#CXXFLAGS = -Wall -Wno-sign-compare -O -DNDEBUG 
# Flags for Rubner's version. Note that Rubner's version does not compile with -Wall
#CXXFLAGS = -DCOMPUTE_RUBNER_VERSION -O -DNDEBUG
MEXEXT = $(shell mexext)
#########################################################


##########################################################
# sources files
##########################################################
SRCSNOMAIN = 
RUBNERSRC= 
# For rubner's version
#RUBNERSRC= rubner_emd.c
SRCSMAIN = demo_FastEMD.cpp
SRCS = $(SRCSNOMAIN) $(SRCSMAIN) $(RUBNERSRC)

MEXCXXSRCNOMAIN = 
MEXCPPSRCNOMAIN = 
MEXSRCMAIN1 = emd_hat_gd_metric_mex.cxx
MEXSRCMAIN2 = emd_hat_mex.cxx
##########################################################


#######################
# executables name
#######################
EXE = demo_FastEMD
#######################


#########################################################
# actions
#########################################################
# TODO: $(MEX1/2).$(MEXEXT) Problem: adds space
all: $(EXE) emd_hat_gd_metric_mex.$(MEXEXT) emd_hat_mex.$(MEXEXT)

$(EXE): $(subst .cpp,.o,$(SRCS))
	$(CXX) $(CXXFLAGS) $^ -o $@

%.o: %.cxx
	mex -c CXX=$(CXX) CC=$(CXX) LD=$(CXX) COMPFLAGS='$(CXXFLAGS)' $<

# TODO: $(MEX1).$(MEXEXT) Problem: adds space
emd_hat_gd_metric_mex.$(MEXEXT): $(subst .cxx,.o,$(MEXSRCMAIN1)) $(subst .cxx,.o,$(MEXCXXSRCNOMAIN)) $(subst .cpp,.o,$(MEXCPPSRCNOMAIN))
	mex CXX=$(CXX) CC=$(CXX) LD=$(CXX) -cxx COMPFLAGS='$(CXXFLAGS)' $^

# TODO: $(MEX2).$(MEXEXT) Problem: adds space
emd_hat_mex.$(MEXEXT): $(subst .cxx,.o,$(MEXSRCMAIN2)) $(subst .cxx,.o,$(MEXCXXSRCNOMAIN)) $(subst .cpp,.o,$(MEXCPPSRCNOMAIN))
	mex CXX=$(CXX) CC=$(CXX) LD=$(CXX) -cxx COMPFLAGS='$(CXXFLAGS)' $^

clean:
	rm *.o $(EXE) *.$(MEXEXT)  -f

depend: $(SRCS) $(MEXCXXSRCNOMAIN) $(MEXCPPSRCNOMAIN) $(MEXSRCMAIN1) $(MEXSRCMAIN2) $(RUBNERSRC)
	makedepend -Y -- $(CXXFLAGS) -- $^

.PHONY: all clean depend

# DO NOT DELETE THIS LINE -- make depend depends on it.

demo_FastEMD.o: emd_hat.hpp EMD_DEFS.hpp flow_utils.hpp emd_hat_impl.hpp
demo_FastEMD.o: min_cost_flow.hpp emd_hat_signatures_interface.hpp tictoc.hpp
emd_hat_gd_metric_mex.o: emd_hat_check_mex.hxx emd_hat_compute_mex.hxx
emd_hat_gd_metric_mex.o: emd_hat.hpp EMD_DEFS.hpp flow_utils.hpp
emd_hat_gd_metric_mex.o: emd_hat_impl.hpp min_cost_flow.hpp
emd_hat_mex.o: emd_hat_check_mex.hxx emd_hat_compute_mex.hxx emd_hat.hpp
emd_hat_mex.o: EMD_DEFS.hpp flow_utils.hpp emd_hat_impl.hpp min_cost_flow.hpp
