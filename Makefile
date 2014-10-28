# compiler options
CXX=g++-4.9
CFLAGS=-fPIC
COMPILER_OPTIONS=-O3
DEBUG_OPTIONS=-g3
BATCH=
prefix=/usr

SHARED_LIB_EXT=.dylib

ifeq ($(uname_S),Linux)
	SHARED_LIB_EXT=.so
endif

ifeq ($(uname_S),Darwin)
	SHARED_LIB_EXT=.dylib
endif

# external libs (linking options)

BOOST= #-I /usr/local/boost_1_49_0/
BOOST_LIBRARIES= #-lboost_system -lboost_thread

INCLUDE_ARCHIVES_START=-Wl,-all_load
INCLUDE_ARCHIVES_END=

LIBRARIES=$(INCLUDE_ARCHIVES_START) -lpthread -lssl /usr/lib/libmiracl.a -lcrypto /usr/local/Cellar/gcc49/4.9.1/lib/gcc/x86_64-apple-darwin13.3.0/4.9.1/libstdc++.a $(INCLUDE_ARCHIVES_END) #-lgmp -lgmpxx 
LIBRARIES_DIR=-L$(prefix)/ssl/lib -L$(prefix)/lib

# target names
OT_MAIN=otmain
OT_LIBRARY=otlib
MOT=mal-ot

# sources
SOURCES_UTIL=util/*.cpp
OBJECTS_UTIL=util/*.o
SOURCES_OTMAINMALICIOUS=mains/otmain-malicious.cpp
OBJECTS_OTMAINMALICIOUS=mains/otmain-malicious.o
SOURCES_OT=ot/*.cpp
OBJECTS_OT=ot/*.o
#OBJECTS_MIRACL=util/Miracl/*.o

# includes

#INCLUDE=-I..  -I/usr/include/glib-2.0/ -I/usr/lib/x86_64-linux-gnu/glib-2.0/include

MIRACL_INCLUDES=-I$(prefix)/include
OPENSSL_INCLUDES=-I$(prefix)/ssl/include
INCLUDE=-I.. $(OPENSSL_INCLUDES) $(MIRACL_INCLUDES)

## targets ##

all: mal-ot

#otlib: ${OBJECTS_UTIL} ${OBJECTS_OT}
#	${CXX} ${SHARED_LIB_OPT} -o libOTExtension${SHARED_LIB_EXT} \
#	${OBJECTS_UTIL} ${OBJECTS_OT} ${MIRACL_PATH} ${LIBRARIES} ${LIBRARIES_DIR}

mal-ot: ${OBJECTS_UTIL} ${OBJECTS_OT} ${OBJECTS_OTMAINMALICIOUS}
	${CXX} ${COMPILER_OPTIONS} -o mal_ot.exe ${CFLAGS} ${DEBUG_OPTIONS} ${OBJECTS_OTMAINMALICIOUS} ${OBJECTS_UTIL} ${OBJECTS_OT} ${LIBRARIES_DIR} ${LIBRARIES}

${OBJECTS_OTMAINMALICIOUS}: ${SOURCES_OTMAINMALICIOUS}
	@echo "compling ot-main..."
	cd mains; ${CXX} -c ${INCLUDE} ${CFLAGS} ${BATCH} ${DEBUG_OPTIONS} *.cpp

${OBJECTS_UTIL}: ${SOURCES_UTIL}
	@echo "compling ot-util..."
	cd util; ${CXX} -c ${INCLUDE} ${CFLAGS} ${BATCH} ${DEBUG_OPTIONS} *.cpp

${OBJECTS_OT}: ${SOURCES_OT}
	@echo "compling ot-src..."
	cd ot; ${CXX} -c ${INCLUDE} ${CFLAGS} ${BATCH} ${DEBUG_OPTIONS} *.cpp

install:
	install -d $(libdir)
	install -d $(prefix)/include/OTExtension/ot
	install -d $(prefix)/include/OTExtension/util
	install -m 0644 libOTExtension${SHARED_LIB_EXT} $(libdir)
	install -m 0644 ot/*.h $(prefix)/include/OTExtension/ot
	install -m 0644 util/*.h $(prefix)/include/OTExtension/util

clean:
	rm -rf *.exe ${OBJECTS_UTIL} ${OBJECTS_OTMAINMALICIOUS} ${OBJECTS_OT}
	rm -f *${SHARED_LIB_EXT}

