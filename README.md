# LoaM Comparison

Light detection and ranging LIDAR systems on-board mobile platforms are in rapid advancement for real-time mapping applications. Modern 3D laser scanners have a high data rate which, coupled with the complexity of their processing methods, makes simultaneous online localisation and mapping (SLAM) a computational challenge. Different 3D LiDAR SLAM algorithms have emerged in recent years, most notably LiDAR Odometry and Mapping and its derivatives. 

This repo performs an implementation of A-LOAM, ISC-LOAM and LeGO-LOAM algorithms and a respective comparison with the total sequences of the Kitti database which includes different environments and routes from a Velodyne HDL-64E sensor.

## Menu
  - [**Package dependency**](#dependency)

  - [**Package install**](#install)

  - [**Prepare data**](#prepare-data)

  - [**KITTI dataset**](#kitti-dataset)

  - [**Run the package**](#run-the-package)

  - [**Paper**](#paper)
  
  - [**Results**](#results)

  - [**Related Package**](#related-package)

  - [**Acknowledgement**](#acknowledgement)


## Dependency

- [ROS](http://wiki.ros.org/ROS/Installation) (tested with Kinetic and Melodic)
- Dependent libs: [Ceres](http://ceres-solver.org/installation.html), [GTSAM](https://github.com/borglab/gtsam/releases), [PCL](https://pointclouds.org/downloads/)

You may run the following shell file to install all the dependent libs (tested on Ubuntu 16.04 & 18.04):
```
./install_dep_lib.sh
```

## Install

Use the following commands to download and compile the package:

```
cd ~/catkin_ws/src
https://github.com/cristianrubioa/methods_lidar_3d
cd ..
catkin_make -j1
```
When you compile the code for the first time, you need to add "-j1" behind "catkin_make" for generating some message types. "-j1" is not needed for future compiling.

## Run the package

Run the launch file:
```
./run.sh <method> <num_sequence>

# <method> [aloam, floam ,iscloam, legoloam]
# <num_sequence> [00, 01, ... 10]
```

```
# Example
./run.sh aloam 00
```

## Prepare data

1. Making new bagfile from KITTI dataset:
```
nano ~/catkin_ws/src/methods_lidar_3d/kitti2bag/launch/kitti2bag.launch
```
Change 'dataset_folder' and 'output_bag_file' to your own directories.

2. Move bagfile to sequence folder:
```
mv <num_sequence>.bag ~/catkin_ws/src/methods_lidar_3d/sequences/<num_sequence>
```
3. Run the launch file:
```
roslaunch kitti2bag kitti2bag.launch
```

## KITTI dataset
Download datasets to test the functionality of the package:

| Sequence | Environment   | Dimension (m×m)| Poses  | Path_length (m)|Odom_dataset  | size |
|:--------:|:-------------:|:--------------:|:------:|:--------------:|:-------------:|:----:|
|    00    | Urban         |   564×496      |  4541  |   3724.187     | [Mega](https://mega.nz/file/lIxiTZ6K#4AZzEqGlFs6HE9F17vt3BsLIyPmIXr4AXvZW6aiYAnk) / [Drive](https://drive.google.com/file/d/1WU0m-NvS9KQbXZn6jo40n6JjdDhO6o_A/view?usp=sharing) | 8.39 GB  |
|    01    | Highway       | 1157×1827      |  1101  |   2453.203     | [Mega](https://mega.nz/file/8Z5UlJTS#w7hpD6vSFofSV0Oq04mQp6SOXnv4tb-5BOX20R_koeE) / [Drive](https://drive.google.com/file/d/1cHwZQtCs0zUa3xco3fnu1RASvEAGMyYy/view?usp=sharing) | 1.79 GB  | 
|    02    | Urban+Country |   599×946      |  4661  |   5067.233     | [Mega](https://mega.nz/file/xdwX3ArR#hLlePrLydBKYOmxWa2stjEP4QMnk5z6UsEOveBaJ9Tk) / [Drive](https://drive.google.com/file/d/1xWUqMM_t7dsVBayfLACWLDsgkxKc-lDD/view?usp=sharing) | 9.0 GB   | 
|    03    | Country       |   471×199      |   801  |    560.888     | [Mega](https://mega.nz/file/lcgQVDiC#VHPCaRyBEMHffKwsJAFzcFXIfEwCfogOoIsjDuf_jBA) / [Drive](https://drive.google.com/file/d/1z4sdvzpF_QCuS0y-ep2A_SmGvFz132WH/view?usp=sharing) | 1.54 GB  |
|    04    | Country       |   0.5×394      |   271  |    393.645     | [Mega](https://mega.nz/file/oJgWAThI#lk1qZ9bdBWLkhIrRMWHn0ZIaXeFCN8yBOU6RJdqIJAU) / [Drive](https://drive.google.com/file/d/1A-DIFzN3UniK7q1VOKXELGTM1N857CL3/view?usp=sharing) | 526.9 MB |
|    05    | Urban         |   479×426      |  2761  |   2205.576     | [Mega](https://mega.nz/file/JNJDBAoR#gcSqsZ2y1lTXngo1uLxsWABa8kfZkpDRnPhABPPhd94) / [Drive](https://drive.google.com/file/d/11hXsXm111SDPW63q7mO5HwIoFiPwODVh/view?usp=sharing) | 5.23 GB  |
|    06    | Urban         |    23×457      |  1101  |   1232.876     | [Mega](https://mega.nz/file/cIgExBJL#-qHJdttg2f_yR5Nj141nR78XihgNyNHucJs-Y1nwXPE) / [Drive](https://drive.google.com/file/d/1outbtPJHIrDwD1vqQhzMgKz6vnNZJ696/view?usp=sharing) | 2.04 GB  |
|    07    | Urban         |   191×209      |  1101  |    694.697     | [Mega](https://mega.nz/file/IJpBGKRa#tUR1CouAODDuKppeU4umkYIsny95RQGIUspTPqBauCA) / [Drive](https://drive.google.com/file/d/1eXOQiND5-11_3b9StDBifjzjfyZ9nXo7/view?usp=sharing) | 2.02 GB  |
|    08    | Urban+Country |   808×391      |  4071  |    3222.795    | [Mega](https://mega.nz/file/EYoWUaZQ#jLToiVIUf9GBxb_su_1Lx0hw1EhB7C3D1Y5SLWMGNRQ) / [Drive](https://drive.google.com/file/d/1Z7TQqYMyFKeRnqR4vgrNjMPkXQy9G-U_/view?usp=sharing) | 7.63 GB  |
|    09    | Urban+Country |   465×568      |  1591  |    1705.051    | [Mega](https://mega.nz/file/YZoEBDrT#rzMU1x_9aMtgOSKa3ctMLoxRl_K6ssw-SdaHuxr0TjI) / [Drive](https://drive.google.com/file/d/1h5Dtz3DRu8Avra5JyEKdEJDZb4cZL1xk/view?usp=sharing) | 3.01 GB  |
|    10    | Urban+Country |   671×177      |  1201  |    919.518     | [Mega](https://mega.nz/file/AZgEGTgR#l3JUGuyyHI-QGTQG9RQUg5evpTNWtrnwRGWUY9j1ztQ) / [Drive](https://drive.google.com/file/d/1ZCMO646624y8rv_gYqiDh4UiKBoi4Gdi/view?usp=sharing) | 2.31 GB  |

## Results 
### Paths:
00 <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/paths/00.png" width="180"> 01 <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/paths/01.png" width="180"> 02 <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/paths/02.png" width="180"> 03 <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/paths/03.png" width="180"> 

04 <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/paths/04.png" width="180"> 05 <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/paths/05.png" width="180"> 06 <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/paths/06.png" width="180"> 07 <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/paths/07.png" width="180"> 

08 <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/paths/08.png" width="180"> 09 <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/paths/09.png" width="180"> 10 <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/paths/10.png" width="180">


### Maps: 
#### A-LOAM   -|-   FLOAM   -|-   ISCLOAM   -|-   LeGO-LOAM

00 <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/00_aloam.png" width="90"> <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/00_floam.png" width="90"> <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/00_iscloam.png" width="90">
<img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/00_legoloam.png" width="90"> |
<img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/01_aloam.png" width="90"> <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/01_floam.png" width="90"> <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/01_iscloam.png" width="90">
<img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/01_legoloam.png" width="90"> 01

02 <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/02_aloam.png" width="90"> <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/02_floam.png" width="90"> <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/02_iscloam.png" width="90">
<img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/02_legoloam.png" width="90"> |
<img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/03_aloam.png" width="90"> <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/03_floam.png" width="90"> <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/03_iscloam.png" width="90">
<img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/03_legoloam.png" width="90"> 03

04 <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/04_aloam.png" width="90"> <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/04_floam.png" width="90"> <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/04_iscloam.png" width="90">
<img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/04_legoloam.png" width="90"> |
<img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/05_aloam.png" width="90"> <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/05_floam.png" width="90"> <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/05_iscloam.png" width="90">
<img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/05_legoloam.png" width="90"> 05

06 <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/06_aloam.png" width="90"> <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/06_floam.png" width="90"> <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/06_iscloam.png" width="90">
<img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/06_legoloam.png" width="90"> |
<img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/07_aloam.png" width="90"> <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/07_floam.png" width="90"> <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/07_iscloam.png" width="90">
<img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/07_legoloam.png" width="90"> 07

08 <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/08_aloam.png" width="90"> <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/08_floam.png" width="90"> <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/08_iscloam.png" width="90">
<img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/08_legoloam.png" width="90"> |
<img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/09_aloam.png" width="90"> <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/09_floam.png" width="90"> <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/09_iscloam.png" width="90">
<img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/09_legoloam.png" width="90"> 09

10 <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/10_aloam.png" width="90"> <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/10_floam.png" width="90"> <img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/10_iscloam.png" width="90">
<img src = "https://github.com/cristianrubioa/methods_lidar_3d/blob/main/Demo/results/maps/10_legoloam.png" width="90"> 

## Related Package

  - [A-LOAM](https://github.com/HKUST-Aerial-Robotics/A-LOAM)
  - [FLOAM](https://github.com/wh200720041/floam)
  - [ISCLOAM](https://github.com/wh200720041/iscloam)
  - [LeGO-LOAM](https://github.com/RobustFieldAutonomyLab/LeGO-LOAM)

## Authors

* [Prof. Harold F MURCIA](www.haroldmurcia.com)
* [Cristian F Rubio](https://www.linkedin.com/in/cristianrubioaguiar/)

## Acknowledgement
This work was supported in part by the Universidad de Ibagué under research project 19-489-INT-
