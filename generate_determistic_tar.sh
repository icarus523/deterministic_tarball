#!/bin/sh

# Generates a Deterministic Tarball with the following default options

print_usage() {
  echo " -d <directory name>"
  echo " -c <ouput archive name : default: archive.tar>"
}

ARCHIVE_NAME="archive.tar"
DIRECTORY="null"

while getopts ":d:c?" opt; do 
  case $opt in
	"d") DIRECTORY=$OPTARG ;;
	"c") ARCHIVE_NAME=$OPTARG ;;
	"?") print_usage; exit 1;;
	"*") echo "Invalid command line parameter" ; exit 1 ;;
  esac
done

[ ! -d $DIRECTORY ] && print_usage && exit 1

# [ -d $DIRECTORY ] && find $DIRECTORY -print0

[ -d $DIRECTORY ] && find $DIRECTORY -print0 | LC_ALL=C sort -z | GZIP=-9n tar --null -T - \
	--no-recursion \
	--owner=root --group=root --numeric-owner \
	--mode=go=rX,u+rw,a-s \
	-zcf $ARCHIVE_NAME

# MODE
# user = read & write
# group & others = r & execute directories (to view directories.
# all = clear set-user-ID and set-group-ID bits for deterministic tar balls
