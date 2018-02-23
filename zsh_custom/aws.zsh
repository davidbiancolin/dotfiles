function aws_create_fpga_image() {

    if [[  "$#" -ne 2 ]]; then
        echo "$0 expects at least two argument: Tarball name, and a label."
        echo "Optionally, pass the bucket name as the second argument."
        return
    fi
    label="$2"
    echo "Making image with tarball: $1, with label: ${label}"
    bucket="biancolin-hello-world"

    if [[ "$#" -eq 3 ]]; then
        bucket=$3
    fi

    echo "Publishing to bucket: ${bucket}\n"
    aws s3 cp $1 s3://$bucket/dcp/

	ami_info=$(aws ec2 create-fpga-image \
               --name firesim \
               --description \"${label}\" \
               --input-storage-location Bucket=$bucket,Key=dcp/$1 \
               --logs-storage-location Bucket=$bucket,Key=logs/ )
    echo $ami_info | mailx -s "[AWS] New AFI: ${label}." $EMAIL
}


function aws_get_f1_spot_fleet() {

    if [[  "$#" -ne 1 ]]; then
        echo "$0 expects one argument.\n"
        echo "1: Launch Specification (JSON)\n"
        return
    fi

    spec=$1
    set -x
    aws ec2 request-spot-fleet --spot-fleet-request-config file://$spec
    set +x
}

function aws_check_afi_status() {

    if [[  "$#" -ne 1 ]]; then
        echo "$0 expects one argument.\n"
        echo "1: afi id\n"
        return
    fi
    set -x
    aws ec2 describe-fpga-images --fpga-image-ids $1 --query "FpgaImages[*].State"
    set +x
}

function aws_ssh() {
    if [[  "$#" -ne 1 ]]; then
        echo "$0 expects the following arguments.\n"
        echo "1: The name of the instance -- used to query the public IP\n"
        return
    fi
    ssh -Y centos@`aws ec2 describe-instances --filters 'Name=tag:Name,Values=$1' --query 'Reservations[*].Instances[*].PrivateIpAddress' | grep -Eo "[0-9\.]+"`
}

function aws_get_named_instace_info() {
    if [[  "$#" -ne 1 ]]; then
        echo "$0 expects the following arguments.\n"
        echo "1: The name of the instance -- used to query the public IP\n"
        return
    fi
    aws ec2 describe-instances --filters "Name=tag:Name,Values=$1"
}

function firesim_get_root() {
    if [[  "$#" -ne 1 ]]; then
        git_dir=$(pwd)
    else
        git_dir=$1
    fi

    top_level=$(cd "$git_dir"; git rev-parse --show-toplevel) 2> /dev/null
    if [[ -n "$top_level" ]]; then
        remote=$(cd "$git_dir"; git remote -v) 2>/dev/null
        if [[ $remote = *"firesim/firesim.git"* ]]; then
            echo "Setting FIRESIM_DIR to ${top_level}"
            export FIRESIM_DIR=$top_level
        else
            next_dir=$(dirname "$top_level")
            get_firesim_dir $next_dir
        fi
    else
        echo "Not in a firesim directory"
    fi
}

alias cdfpga='cd $FIRESIM_DIR/platforms/f1/aws-fpga/hdk/cl/developer_designs'
alias cdsim='cd $FIRESIM_DIR/sim'
alias cdsw='cd $FIRESIM_DIR/sw/firesim-software'
alias cdman='cd $FIRESIM_DIR/deploy'
