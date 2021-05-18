CXXFLAGS += -O3 -Wall -shared -std=c++11 -fPIC -fdiagnostics-color
CPPFLAGS += $(shell python3.6 -m pybind11 --includes)
LIBNAME = helpers
LIBEXT = $(shell python3.6-config --extension-suffix)

default: $(LIBNAME)$(LIBEXT)

%$(LIBEXT): %.cpp
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $< -o $@
