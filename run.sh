#!/bin/bash 

# Author : Cristian Rubio 
# Email  : cristianrubioa@gmail.com

# ARG User
METHOD=$1
SEQUENCE=$2 

display_usage() { 
	echo -e "Usage: $0 <method> <sequence>"
    echo "<method> {loam, legoloam, floam, iscloam}"
    echo "<sequence> {00, 01, 02, ... 10}"  
} 

# if less than two arguments supplied, display usage 
if [  $# -le 1 ] 
then 
	display_usage ; exit 1
elif [[ ( $# == "--help") ||  $# == "-h" ]]  # check supplied -h or --help
then 
	display_usage ; exit 0
fi

# Create PATH_SEQ
mkdir -p sequences ; cd sequences;
COUNT=0; NUMS_SEQUENCE=10
while [ $COUNT -lt $NUMS_SEQUENCE ]
do
    #echo "COUNT = 0$COUNT"
    mkdir -p "0"$COUNT 
    ((COUNT++))
done
mkdir -p 10 ; cd .. ; echo "" ; echo "- Created directories : [PATH_SEQ completed]" ; echo ""


SPACES="          "
NAME_I=$SEQUENCE ; EXT_I=".bag" ; FILE_I=$NAME_I$EXT_I
SUFFIX_O="_pred" ; EXT_O=".txt" ; FILE_O=$NAME_I"_"$METHOD$SUFFIX_O$EXT_O

echo "==================================================" 
echo "                METHOD -> [$METHOD]" 
echo "==================================================" ; echo ""
PATH_SEQ=$(pwd)"/sequences/"$SEQUENCE"/" ; echo "* PATH   : ""/sequences/"$SEQUENCE"/"
INPUT_FILE=$PATH_SEQ$FILE_I              ; echo "* INPUT  : $SPACES └───" $FILE_I
OUTPUT_FILE=$PATH_SEQ$FILE_O             ; echo "* OUTPUT : $SPACES └───" $FILE_O ; echo ""

rm -rf $OUTPUT_FILE || true

if [ $METHOD = "iscloam" ]
then
    echo ">> roslaunch iscloam iscloam.launch" ; echo ""
    roslaunch iscloam iscloam.launch INPUT:=$INPUT_FILE OUTPUT:=$OUTPUT_FILE
else
    echo "No method"
fi