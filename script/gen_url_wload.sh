#!/bin/bash

# Fixed folder hierachy
YCSB_DIR="../../YCSB"
URL_DIR="../urls"
OUT_YCSB_DIR="../output_ycsb"
OUT_URL_DIR="../output_urls"
SCRIPT_DIR="."

# Configurable arguments
RECORD_COUNT="recordcount=1000"
RECORD_COUNT_FILE="small_1k.dat"

# Property file arguments
URL_INPUT="large_urls_1M.txt"
URL_SAMPLE_SIZE=1000000
LOAD_YCSB="loade_1K.dat"
TXN_YCSB="txnse_1K.dat"
LOAD_URL="loade_urls_1K.dat"
TXN_URL="txnse_urls_1K.dat"

# Workload specification
WORKLOAD="workloade"

# URL MAP Program
URLMAP="urlMap.py"
URLMAP_ARGS="urlMapArgs.property"

function set_recordcount ()
{
    echo RECORD_COUNT > $SCRIPT_DIR
}

function set_property ()
{
    echo $URL_DIR/$URL_INPUT > $1
    echo $URL_SAMPLE_SIZE >> $1
    echo $OUT_YCSB_DIR/$LOAD_YCSB >> $1
    echo $OUT_YCSB_DIR/$TXN_YCSB >> $1
    echo $OUT_URL_DIR/$LOAD_URL >> $1
    echo $OUT_URL_DIR/$TXN_URL >> $1
}

set_recordcount

$YCSB_DIR/bin/ycsb load basic -P $YCSB_DIR/workloads/$WORKLOAD -P $SCRIPT_DIR/$RECORD_COUNT_FILE -s > $OUT_YCSB_DIR/$LOAD_YCSB

$YCSB_DIR/bin/ycsb run basic -P $YCSB_DIR/workloads/$WORKLOAD -P $SCRIPT_DIR/$RECORD_COUNT_FILE -s > $OUT_YCSB_DIR/$TXN_YCSB

set_property $SCRIPT_DIR/$URLMAP_ARGS

python $SCRIPT_DIR/$URLMAP $SCRIPT_DIR/$URLMAP_ARGS