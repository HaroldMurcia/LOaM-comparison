#!/bin/bash 

# Author : Cristian Rubio 
# Email  : cristianrubioa@gmail.com

# exit on errors
set -e

echo "===================================================" 
echo "   >> Begin to install all the dependent libs <<"
echo "===================================================\n" 

Install() {
    echo "\n=============================" 
    echo " * Install: -> [$1]"
    echo "=============================" 
}

Done() {
    if [ $1 = "Finished" ]
    then
        echo "\n\b * Task completed!"
        echo "check that each dependency has been installed completely and correctly"
    else
        echo "-- ( \"$1\" INSTALLATION DONE )"
    fi
}


cd .. ; mkdir -p dependent_libs ; cd dependent_libs
echo " * Create a new folder called <dependent_libs> at current path."

sudo apt-get update

# CMake
sudo apt-get install cmake
# google-glog + gflags
sudo apt-get install -y libgoogle-glog-dev libgflags-dev
# BLAS & LAPACK
sudo apt-get install -y libatlas-base-dev
# Eigen3
sudo apt-get install -y libeigen3-dev
# SuiteSparse and CXSparse (optional)
sudo apt-get install libsuitesparse-dev

Install PCL
sudo apt-get install -y libpcl-dev pcl-tools libproj-dev
Done PCL

Install Ceres
git clone https://ceres-solver.googlesource.com/ceres-solver
mkdir ceres-bin ; cd ceres-bin
cmake ../ceres-solver
make -j3 ; sudo make install
Done Ceres

Install GTSAM
wget https://github.com/borglab/gtsam/archive/4.0.3.zip
unzip 4.0.3.zip ; cd gtsam-4.0.3
mkdir build && cd build
cmake .. ; sudo make install
Done GTSAM

# echo "For the python toolboxs of the project"
# Install evo"
# pip install evo --upgrade --no-binary evo

Done Finished

# you might then delete the dependent_libs folder
cd cd ~/catkin_ws/src ; rm -rf dependent_libs