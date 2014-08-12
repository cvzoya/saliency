#########################################################
# class and executable name
#########################################################
CLASS= emd_hat
EXE= $(CLASS)_main
NATIVE_ADDITION= native
#########################################################

#########################################################
# compiler stuff
#########################################################
CXX= g++
CC= gcc
CXXFLAGS = -O -DNDEBUG
JAVA= javac
#########################################################

#########################################################
# Creating the shared library
#########################################################
lib$(CLASS)_$(NATIVE_ADDITION).so:
	@echo If this compliation fails, you\'ll need to find out how to compile a shared library that includes jni.h to your specific computer architectecture.
	@echo
	g++ $(CXXFLAGS) -shared -O -I/usr/local/java/current/include -I/usr/local/java/current/include/linux/ -I.. -shared $(CLASS)_$(NATIVE_ADDITION).cpp -o $@


#########################################################

#########################################################
# For creating the interface
#########################################################
$(CLASS).java:
	@touch $@
	@echo class $(CLASS) { >> $@
	@echo     static {         >> $@
	@echo       // We used here loadLibrary which means that you\'ll have to run your main function with -Djava.library.path=. >> $@
	@echo       // For example if your main function is in demo_FastEMD.java like here. You\'ll run it with: >> $@
	@echo       // java -Djava.library.path=. demo_FastEMD >> $@
	@echo       // Another option is to use here load instead of loadLibrary with the full path. Something like this: >> $@
	@echo       // System.load\(\"/cs/vis/ofirpele/emd/FastEMD/FastEMD/JAVA/lib$(CLASS)_$(NATIVE_ADDITION).so\"\)\; >> $@
	@echo       // Use System.out.println\(System.mapLibraryName\(\"emd_hat_native\"\)\)\; to see how your specific architectecture >> $@
	@echo       // names shared libraries. >> $@
	@echo      try{ >> $@
	@echo        System.loadLibrary\(\"$(CLASS)\"\)\; >> $@
	@echo      } catch \(java.lang.UnsatisfiedLinkError e\) { >> $@
	@echo        System.out.println\(\"====================================================\"\)\; >> $@
	@echo        System.out.println\(\"Could not find $(CLASS)_$(NATIVE_ADDITION) library. Run with:\"\)\; >> $@
	@echo        System.out.println\(\"java -Djava.library.path=.\"\)\; >> $@
	@echo	     System.out.println\(\"If it\'s not the problem, you\'ll need to copy a compiled library that suites your architectecture from compiled_$(CLASS)_$(NATIVE_ADDITION)_libs/\"\)\; >> $@
	@echo        System.out.println\(\"Or compile the library \(from emd_hat_native.cpp\)\"\)\; >> $@
	@echo        System.out.println\(\"====================================================\"\)\; >> $@
	@echo        System.out.println\(\"\"\)\; >> $@
	@echo        throw e\; >> $@
	@echo      } >> $@
	@echo     }                >> $@
	@echo } >> $@
	@echo ============================================
	@echo Now implement $@
	@echo ============================================

$(CLASS).class:
	javac $(CLASS).java

$(CLASS)_$(NATIVE_ADDITION).hpp:
	javah -jni -I. $(CLASS) -o $@

$(CLASS)_$(NATIVE_ADDITION).cpp: $(CLASS)_$(NATIVE_ADDITION).hpp 
	@touch $@
	@echo \#include \"$<\" >> $@
	@echo >> $@
	@grep JNICALL $< >> $@
	@echo ============================================
	@echo Now implement $@
	@echo ============================================
#########################################################

clean:
	rm *.so *.class -f

.PHONY: all clean depend
