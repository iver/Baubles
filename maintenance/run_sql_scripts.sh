#!/bin/bash
# Iván Jaimes
# iver(at)iver.mx
# 2013
# Usage: run_sql_scripts [ -u username -d database -b base_dir -a action ]
#
#	-u username to connect mysql server
#	-d [database] optional, destination database when script does not include
#	-b [base_dir] optional, scripts base directory
#	-a [nodata | full | load | data] optional, load by default
#			     where:
#			       nodata - dump database structure
#			       data - dump database data only
#			       full - dump complete
#			       load - load all scripts from [base_dir]
#
# Note: The script will prompt for a password, you cannot specify it as command line argument for security reasons

PROG_NAME=$(basename $0)
USER=""
PASSWORD=""
BASE_DIR=${PWD}
DATABASE=""
FILE_DIR=""
ACTION="load"

#MYSQL="/usr/bin/mysql"
MYSQL="/usr/local/mysql/bin/mysql"
DUMP="/usr/local/mysql/bin/mysqldump"

while getopts u:d:b:a: OPTION
do
    case ${OPTION} in
        u) USER=${OPTARG};;
        d) DATABASE=${OPTARG};;
        b) BASE_DIR=${OPTARG};;
		a) ACTION=${OPTARG};;
        ?) 
			echo ""
			echo "Usage: ${PROG_NAME} [ -u username -d database -b base_dir -a action]"
			echo "	-u username to connect mysql server"
			echo "	-d [database] optional, destination database when script does not include"
			echo "	-b [base_dir] optional, scripts base directory "
			echo "	-a [nodata | full | load | data] optional, load by default "
			echo "     where:"
			echo "       nodata - dump database structure"
			echo "       data - dump database data only"
			echo "       full - dump complete"
			echo "       load - load all scripts from [base_dir]"
           exit 2;;
    esac
done

if [ "$USER" != '' ]; then
    echo "Enter password for" $USER":"
    oldmodes=`stty -g`
    stty -echo
    read PASSWORD
    stty $oldmodes
fi

if [ "$ACTION" == 'load' ]; then
   # dump each sql script in ${BASE_DIR}
   for file in $BASE_DIR*.sql; do
    	$MYSQL -u $USER --password=$PASSWORD $DATABASE < $file
        echo " ... archivo $file CARGADO! ..."
   done
fi

OUTPUT=$BASE_DIR"/"$DATABASE

if [ "$ACTION" == 'full' ]; then
   $DUMP --force --opt -u $USER --password=$PASSWORD --databases $DATABASE > $OUTPUT"_full.sql"
fi

if [ "$ACTION" == 'data' ]; then
   $DUMP -u $USER --password=$PASSWORD --no-create-info --complete-insert --skip-extended-insert --databases $DATABASE > $OUTPUT"_data.sql"
fi

if [ "$ACTION" == 'nodata' ]; then
   $DUMP -u $USER --password=$PASSWORD --no-data $DATABASE > $OUTPUT"_nodata.sql"
fi
