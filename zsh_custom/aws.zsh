function aws_create_fpga_image() {

    if [[  "$#" -ne 2 ]]; then
        echo "$0 expects two arguments. Tarball & Bucket Name.\n"
        return
    fi
    echo "Making image with tarball: $1"
    echo "Publishing to bucket: $2\n"
    set -ex
    aws s3 cp $1 s3://$2/dcp/

	ami_info=$(aws ec2 create-fpga-image \
               --name firesim \
               --description firesim \
               --input-storage-location Bucket=$2,Key=dcp/$1 \
               --logs-storage-location Bucket=$2,Key=logs/ )
    echo $ami_info | mailx -s "[AWS] New AMI request issued." $EMAIL
    set -ex
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
