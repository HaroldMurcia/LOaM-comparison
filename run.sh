#!/bin/bash 

# Author : Cristian Rubio 
# Email  : cristianrubioa@gmail.com

# ARG User
METHOD=$1
SEQUENCE=$2 

# Usage launch file
USAGE() { 
    echo -e "Usage: $0 <method> <sequence>"
    echo "<method> {loam, floam, iscloam, legoloam}"
    echo "<sequence> {00, 01, 02, ... 10}"  
} 

# If less than two arguments supplied, display usage 
if [  $# -le 1 ] 
then 
	USAGE ; exit 1
elif [[ ( $# == "--help") ||  $# == "-h" ]]  # check supplied -h or --help
then 
	USAGE ; exit 0
fi

# Create folder <map>.pcd 
CE() {
    mkdir -p pcd ; cd pcd
    rm -rf *.pcd ; cd ../..	
}

# Create PATH_SEQ
mkdir -p sequences ; cd sequences;
COUNT=0; NUMS_SEQUENCE=10
while [ $COUNT -lt $NUMS_SEQUENCE ]
do
    #echo "COUNT = 0$COUNT"
    mkdir -p "0"$COUNT 
    cd "0"$COUNT ; CE
    ((COUNT++))
done
mkdir -p 10 ; cd 10; CE ; cd .. ;

# Object file names
SPACES="          "
NAME_I=$SEQUENCE ; EXT_I=".bag" ; FILE_I=$NAME_I$EXT_I
EXT_TRAJ="_traj.txt" ; FILE_TRAJ=$NAME_I"_"$METHOD$EXT_TRAJ
SUFFIX_MAP="_map" ; FILE_MAP=$NAME_I"_"$METHOD$SUFFIX_MAP

# Tree directory
echo "==================================================" 
echo "                METHOD -> [$METHOD]" 
echo "==================================================" ; echo ""
echo " * PATH   : /sequences/$SEQUENCE/"
echo " * INPUT  : $SPACES └─── $FILE_I"
echo " * OUTPUT : $SPACES └─── $FILE_TRAJ" 
echo "            $SPACES └─── /pcd/"
echo "            $SPACES       └─── $FILE_MAP.pcd" ; echo ""

PATH_SEQ=$(pwd)"/sequences/"$SEQUENCE"/" 
INPUT_FILE=$PATH_SEQ$FILE_I              
OUTPUT_TRAJ=$PATH_SEQ$FILE_TRAJ   
OUTPUT_MAP=$PATH_SEQ"/pcd/"$FILE_MAP"_"  

# Find if <file>.bag is corect
if [ ! -f $INPUT_FILE ]
then
    echo "[ERROR]: File \"$FILE_I\" not found!" ; exit 1
fi        

# Clean old <file_traj.txt>
rm -rf $OUTPUT_TRAJ || true

# Execute command
EXE() {
    echo " >> $1 $2 $3" ; echo ""
    $@
}

# Filter "<final-map>.pcd"
FILTER() {
    cd $PATH_SEQ"/pcd/"
    COUNT=$(ls | wc -l); let sub=$COUNT-1
    MAP=$(ls | sort -r | head -1)
    FILES=$(ls | sort -n | head -$sub)
    for FILE in $FILES 
    do
	rm -f $FILE
    done
    mv $MAP $FILE_MAP".pcd"
}

# Cases
if [ $METHOD = "aloam" ]
then
    EXE roslaunch aloam_velodyne aloam_velodyne_HDL_64.launch INPUT:=$INPUT_FILE OUTPUT_TRAJ:=$OUTPUT_TRAJ OUTPUT_MAP:=$OUTPUT_MAP ; FILTER
elif [ $METHOD = "floam" ]
then
    EXE roslaunch floam floam_mapping.launch INPUT:=$INPUT_FILE OUTPUT_TRAJ:=$OUTPUT_TRAJ OUTPUT_MAP:=$OUTPUT_MAP ; FILTER
elif [ $METHOD = "iscloam" ]
then
    EXE roslaunch iscloam iscloam_mapping.launch INPUT:=$INPUT_FILE OUTPUT_TRAJ:=$OUTPUT_TRAJ OUTPUT_MAP:=$OUTPUT_MAP ; FILTER
elif [ $METHOD = "legoloam" ]
then
    EXE roslaunch lego_loam run.launch INPUT:=$INPUT_FILE OUTPUT_TRAJ:=$OUTPUT_TRAJ OUTPUT_MAP:=$OUTPUT_MAP ; FILTER
else
    echo "[ERROR]: The \"$METHOD\" method does not exist!" ; echo ""
    USAGE ; exit 0
fi