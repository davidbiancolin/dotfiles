#!/bin/bash
set -ex

hosts=(a6 a7 a8)
#This does not work for ivy since it lacks many of the packages that the other
# mill machines have. So long as you build lua once it's fine.
#hosts=(ivy)

for host in ${hosts[@]}; do
    echo $host
    qsub -l nodes=$host cluster_setup.sh
done
