#!/bin/sh
# Iván Jaimes <ivan.iver@gmail.com>
# File: git_deploy.sh

PROG_NAME=$(basename $0)
OUTPUTDIR=${PWD}
ZIP_ENABLED=0
BRANCH=""

while getopts b:o:z OPTION
do
    case ${OPTION} in
        b) BRANCH=${OPTARG};;
        o) OUTPUTDIR=${OPTARG};;
        z) ZIP_ENABLED=1;;
        ?) echo ""
		   echo "    Usage: ${PROG_NAME} [ -b branch -o output_dir -z ]"
		   echo "    Where: -z will enable zip format"
           exit 2;;
    esac
done

if [ ! -d "$OUTPUTDIR" ]; then
    mkdir -p $OUTPUTDIR
fi
# Replace slash with underscore
FILENAME=${BRANCH//\//_}
FILENAME=${FILENAME//&/}
echo "$FILENAME"
if [ $ZIP_ENABLED == 1 ]; then
	echo "Creating zip file to deploy ... "
	git archive --format zip --output "$OUTPUTDIR/$FILENAME.zip" $BRANCH
	echo " ... Finished "
else
	echo "Creating files to deploy ..."
	git archive --output "$OUTPUTDIR/$FILENAME" $BRANCH
	echo " ... Finished "
fi