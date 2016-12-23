#!/bin/bash
#pascal tempier 2016
#set -x
echo "Script start $(date +"%Y-%m-%d_%H-%m-%S")"

VERS="$1"
BASE="/var/urbackup/"
DATE="$(date +"%Y-%m-%d_%H-%m-%S")"
BUSR="urbackup"
BGRP="urbackup"
DEFA="2.1.8%20beta"
#DEFA="2.0.34"
#=======================================
echo "Using parameters :"
echo "#======================#"

if [ -z "$VERS" ]
then
	echo "using default $DEFA"
	VERS="$DEFA"
fi

if echo "$VERS" | grep -q 'beta'
then
	echo "grabbing beta : $VERS"
	BURL="https://ssl.webpack.de/beta.urbackup.org/Client"

else
	echo "grabbing stable : $VERS"
	BURL="https://hndl.urbackup.org/Client/"
fi

echo "Base client url : $BURL"

if [ ! -e "$BASE" ]
then
	echo "Base folder doesn t exists, exiting : $BASE"
	exit 1
else
	echo "Base folder : $BASE"
fi

if  ! grep -q "$BUSR" "/etc/passwd" 
then
	echo "User doesn't exists, exiting : $USER"
	exit 1
else
	echo "User : $BUSR"
fi

if  ! grep -q "$BGRP" "/etc/group" 
then
        echo "Group doesn't exists, exiting : $GRPP"
	exit 1
else
	echo "Group : $BGRP"
fi

echo "#===========================#"
#==================================

function mv_and_down {

	local DFILE="$1"
	if [ -z "$BASE/$DFILE" ]
	then
		echo "undefined file, exiting"
		exit 1
	fi

	echo  "Getting $DFILE" 

	mv  -f  "$BASE/$DFILE" "$BASE/$DFILE.bak"

	if [ -e "$BASE/$DFILE.bak_$VERS" ]
	then
		echo "Version already downloaded"
		cp -f "$BASE/$DFILE.bak_$VERS" "$BASE/$DFILE"
	else
		rm -f "$BASE/$DFILE"
	  cd    "$BASE"
		echo "From : $BURL/$VERS/update/$DFILE"
		wget -q "$BURL/$VERS/update/$DFILE"
		chown "$BUSR:$BGRP" "$BASE/$DFILE" 
		cp -f "$BASE/$DFILE" "$BASE/$DFILE.bak_$VERS"
	fi


	if [ ! -e "$BASE/$DFILE" ]
	then
		echo "something gone wrong, restoring old client"
	        cp  -f  "$BASE/$DFILE.bak" "$BASE/$DFILE" 
	fi

	echo "versions: "
	ls -l "$BASE/$DFILE"
	ls -l "$BASE/$DFILE."*
}

cd "$BASE"

mv_and_down "UrBackupUpdate.exe"
mv_and_down "UrBackupUpdate.sig"
mv_and_down "UrBackupUpdate.sig2"
mv_and_down "version.txt"
mv_and_down "UrBackupUpdateLinux.sh"
mv_and_down "UrBackupUpdateLinux.sig2"
mv_and_down "version_linux.txt"
mv_and_down "version_mac.txt"
mv_and_down "UrBackupUpdateMac.sig2"

echo "script finished : $(date +"%Y-%m-%d_%H-%m-%S")"
