#!/bin/bash
#"***************************************************************************************************"
#  common initialization
#"***************************************************************************************************"

# select master or some GitHub hash version, and whether or not to force a clean
THIS_CHECKOUT=master
THIS_CLEAN=true

# perform some version control checks on this file
./gitcheck.sh $0

# initialize some environment variables and perform some sanity checks
. ./init.sh

# we don't want tee to capture exit codes
set -o pipefail

#"***************************************************************************************************"
# install the repo of pre-compile binaries
#"***************************************************************************************************"
THIS_LOG=$LOG_DIRECTORY"/"$THIS_FILE_NAME"_ulx3s-bin_"$LOG_SUFFIX".log"

echo "***************************************************************************************************"
echo " ulx3s-bin. Saving log to $THIS_LOG"
echo "***************************************************************************************************"

# Call the common github checkout:

pushd .
cd "$WORKSPACE"

$SAVED_CURRENT_PATH/fetch_github.sh https://github.com/ulx3s/ulx3s-bin.git ulx3s-bin $THIS_CHECKOUT  2>&1 | tee -a "$THIS_LOG"
$SAVED_CURRENT_PATH/check_for_error.sh                                                                 $?          "$THIS_LOG"

cd "$WORKSPACE"/ulx3s-bin

# TODO - any checks here?

popd
echo "Completed $0"                                                   | tee -a "$THIS_LOG"
echo "----------------------------------"