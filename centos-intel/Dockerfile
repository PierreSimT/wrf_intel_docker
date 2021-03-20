FROM centos:7

COPY ./oneAPI.repo /etc/yum.repos.d

# PROBAR SIN MPI HACIENDO BUILD DE MPICH intel-oneapi-mpi intel-oneapi-mpi-devel

RUN rpm --import https://yum.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB && yum -y update \
  && yum -y install file bash csh \
  time wget which libcurl-devel \
  epel-release \
  && yum -y group install "Development Tools" \
  && yum -y install cmake intel-oneapi-compiler-dpcpp-cpp-and-cpp-classic intel-oneapi-compiler-fortran \ 
  && yum clean all

ENV CC icc
ENV FC ifort
ENV F90 ifort
ENV CXX icpc

# Set environment for interactive container shells
RUN echo "source /opt/intel/oneapi/compiler/latest/env/vars.sh"  >> /etc/bashrc \
 && echo export CC=icc >> /etc/bashrc && echo export FC=ifort >> /etc/bashrc \
 && echo export F90=ifort >> /etc/bashrc && echo export CXX=icpc >> /etc/bashrc \
 && echo ulimit -s unlimited >> /etc/bashrc