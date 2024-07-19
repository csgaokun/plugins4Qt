#!/bin/bash
result=`pwd`
echo $result
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${result}
echo  $LD_LIBRARY_PATH
./HldCabinClient
