#!/bin/bash

if [[ -z $TPARTY_HOME ]]; then
    echo 'Not defined TPARTY_HOME variable.'
    exit 1
fi

TPARTY_LOCAL=$TPARTY_HOME/local
TPARTY_TMP=$TPARTY_HOME/tmp

## Don't remove DEPENDENCIES variable.
DEPENDENCIES=

NAME='wxWidgets-3.1.0'
URL='https://codeload.github.com/wxWidgets/wxWidgets/tar.gz/v3.1.0'
MD5='6d2af648c5d0b2d366e7050d06b9a89f'
TEMP_DIR="$TPARTY_TMP/build"
DEST_NAME="$NAME.tar.gz"
WORK_NAME="$NAME"
ALREADY="$TPARTY_LOCAL/include/wx-3.1/wx/config.h"
LOG_PATH="$TEMP_DIR/$NAME-`datetime`.log"

PLATFORM=`platform`
CORE_COUNT=`cpucount`
let "THREAD_COUNT = $CORE_COUNT * 2"

case $PLATFORM in
Windows)
    THREAD_FLAG=''
    ;;
*)
    THREAD_FLAG=-j$THREAD_COUNT
    ;;
esac

function runCommon {
    code=$?; [[ $code != 0 ]] && exit $code
    ./configure --prefix=$TPARTY_LOCAL >> $LOG_PATH

    code=$?; [[ $code != 0 ]] && exit $code
    make $THREAD_FLAG >> $LOG_PATH

    code=$?; [[ $code != 0 ]] && exit $code
    make install >> $LOG_PATH
}

LINUX_FUNC=runCommon
MACOSX_FUNC=runCommon
WINDOWS_FUNC=runCommon

. general-build "$NAME" "$URL" "$MD5" "$TEMP_DIR"    \
    "$DEST_NAME" "$WORK_NAME" "$ALREADY" "$LOG_PATH" \
    "$LINUX_FUNC" "$MACOSX_FUNC" "$WINDOWS_FUNC"     \
    "$DEPENDENCIES"
