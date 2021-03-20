#
FROM pierresimt/centos-intel

# ENV WRF_VERSION 4.2.2
# ENV WPS_VERSION 4.2

# Build the libraries with a parallel Make
ENV J "-j 16"

RUN mkdir -p /opt/wrf/lib

# export LD_LIBRARY_PATH=/opt/wrf/lib/lib:$LD_LIBRARY_PATH
ENV LD_LIBRARY_PATH /opt/wrf/lib/lib
# export LDFLAGS=-L/opt/wrf/lib/lib
ENV LDFLAGS -L/opt/wrf/lib/lib
# export CPPFLAGS=-I/opt/wrf/lib/include
ENV CPPFLAGS -I/opt/wrf/lib/include

# Build szip library
RUN mkdir -p /opt/src/ && source /opt/intel/oneapi/compiler/latest/env/vars.sh \
  && cd /opt/src \
  && curl -L -O https://support.hdfgroup.org/ftp/lib-external/szip/2.1.1/src/szip-2.1.1.tar.gz \
  && tar -xvf szip-2.1.1.tar.gz \
  && cd szip-2.1.1 && ./configure --prefix=/opt/wrf/lib \
  && make && make install

# Build zlib library
RUN  source /opt/intel/oneapi/compiler/latest/env/vars.sh \
  && cd /opt/src/ \
  && git clone https://github.com/madler/zlib.git \
  && cd zlib \
  && git checkout v1.2.11 \
  && ./configure --prefix=/opt/wrf/lib \
  && make \
  && make install

# Build HDF5 libraries
RUN source /opt/intel/oneapi/compiler/latest/env/vars.sh \
 && cd /opt/src/ \
 && git clone https://github.com/HDFGroup/hdf5 \
 && cd hdf5 \
 && git checkout hdf5-1_12_0 \
 && ./configure --enable-fortran --with-zlib=/opt/wrf/lib --with-szip=/opt/wrf/lib --prefix=/opt/wrf/lib \
 && make \
 && make install

# export HDF5=/opt/wrf/lib
ENV HDF5 /opt/wrf/lib

# Build netCDF C 
RUN source /opt/intel/oneapi/compiler/latest/env/vars.sh \
 && cd /opt/src \
 && curl -L -O https://github.com/Unidata/netcdf-c/archive/v4.7.4.tar.gz \
 && curl -L -O https://github.com/Unidata/netcdf-fortran/archive/v4.5.3.tar.gz \
 && tar -xf v4.7.4.tar.gz \
 && cd netcdf-c-4.7.4 \
 && ./configure --prefix=/opt/wrf/lib \
 && make \
 && make install

# and Fortran libraries
RUN source /opt/intel/oneapi/compiler/latest/env/vars.sh \
 && cd /opt/src \
 && tar -xf v4.5.3.tar.gz \
 && cd netcdf-fortran-4.5.3/ \
 && ./configure --prefix=/opt/wrf/lib \
 && make \
 && make install 

# export NETCDF=/opt/wrf/lib
ENV NETCDF /opt/wrf/lib

# Build MPICH from source
RUN source /opt/intel/oneapi/compiler/latest/env/vars.sh \
  && cd /opt/src \
  && curl -L -O http://www.mpich.org/static/downloads/3.4.1/mpich-3.4.1.tar.gz \
  && tar -xf mpich-3.4.1.tar.gz \
  && cd mpich-3.4.1 \
  && unset F90 \
  && ./configure --prefix=/opt/wrf/lib --with-device=ch4:ofi --enable-cxx --enable-fortran=all \
  --enable-threads=multiple --with-pm=hydra  \
  && make && make install 
# --with-thread-package=posix
# export F90=ifort

# export PATH=/opt/wrf/lib/bin:$PATH
ENV PATH="/opt/wrf/lib/bin:${PATH}"

# Build libpng from source
RUN source /opt/intel/oneapi/compiler/latest/env/vars.sh \
  && cd /opt/src \
  && curl -L -O https://sourceforge.net/projects/libpng/files/libpng16/1.6.37/libpng-1.6.37.tar.gz \
  && tar -xvf libpng-1.6.37.tar.gz \
  && cd libpng-1.6.37 \
  && ./configure --prefix=/opt/wrf/lib \
  && make && make install

# Build Jasper from source
RUN source /opt/intel/oneapi/compiler/latest/env/vars.sh \
  && cd /opt/src \
  && curl -L -O https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.29.tar.gz \
  && tar -xvf jasper-1.900.29.tar.gz \
  && cd jasper-1.900.29 \
  && ./configure --prefix=/opt/wrf/lib \
  && make \
  && make install

# export JASPERLIB=/opt/wrf/lib/lib
ENV JASPERLIB /opt/wrf/lib/lib
# export JASPERINC=/opt/lib/include
ENV JASPERINC /opt/wrf/lib/include

RUN mkdir -p  /opt/wrf/WPS_GEOG /opt/wrf/wrfinput /opt/wrf/wrfoutput /opt/wrf/WRF /opt/wrf/WPS

# # Download WRF source
RUN source /opt/intel/oneapi/compiler/latest/env/vars.sh \
  && cd /opt/wrf \
  && git clone https://github.com/wrf-model/WRF.git  \
  && cd WRF \
  && git checkout v4.2.2 

ENV WRFDIR /opt/wrf/WRF

# Download WPS source
RUN source /opt/intel/oneapi/compiler/latest/env/vars.sh \
  && cd /opt/wrf \
  && git clone https://github.com/wrf-model/WPS.git  \
  && cd WPS \
  && git checkout v4.2

WORKDIR /opt/wrf

CMD ["/bin/bash"]
