#!/bin/bash 

# Author : Cristian Rubio 
# Email  : cristianrubioa@gmail.com

echo "==================================================" 
echo "     Begin to install all the dependent libs"
echo "==================================================" 

cd .. ; mkdir dependent_libs ; cd dependent_libs
echo "Create a new folder called dependent_libs at current path"

sudo apt-get update

# CMake
sudo apt-get install cmake
# google-glog + gflags
sudo apt-get install libgoogle-glog-dev libgflags-dev
# BLAS & LAPACK
sudo apt-get install libatlas-base-dev
# Eigen3
sudo apt-get install libeigen3-dev
# SuiteSparse and CXSparse (optional)
sudo apt-get install libsuitesparse-dev

echo "Install [PCL]"
sudo apt-get install libpcl-dev pcl-tools libproj-dev
echo "Install [PCL] done"

echo "Install [Ceres]"
git clone https://ceres-solver.googlesource.com/ceres-solver
mkdir ceres-bin ; cd ceres-bin
cmake ../ceres-solver
make -j3 ; make install
echo "Install [Ceres] done"

echo "Install [GTSAM]"
git clone https://github.com/borglab/gtsam/archive/4.0.3.zip
unzip gtsam-4.0.3.zip ; cd gtsam-4.0.3
mkdir build && cd build
cmake .. ; sudo make install
echo "Install [GTSAM] done"

# echo "For the python toolboxs of the project"
# echo "Install python dependence"
# sudo pip3 install -r ./python/requirements.txt
# echo "Install python dependence done"
# echo "install evaluation tool"
# pip install evo --upgrade --no-binary evo
# echo "install evaluation tool done"

echo "Finished"

# you might then delete the dependent_libs folder
cd .. ; rm -rf ./dependent_libs

# test pass on Ubuntu 18.04
