#!/bin/bash
set -ex

hosts=(a1 a3 a4)

COPY_PRIVATE_KEY=false
KEY_NAME=id_rsa
COPY_ZSHRC_LOCAL=false
#This does not work for ivy since it lacks many of the packages that the other
# mill machines have. So long as you build lua once it's fine.
#hosts=(ivy)

if $COPY_PRIVATE_KEY ; then
    for host in ${hosts[@]}; do
        echo $host
        scp ~/.ssh/$KEY_NAME $host:~/.ssh/
    done
fi

if $COPY_ZSHRC_LOCAL ; then
    for host in ${hosts[@]}; do
        scp ~/.zshrc_local $host:~/
    done
fi

for host in ${hosts[@]}; do
    echo $host
    qsub -l nodes=$host cluster_setup.sh
done
