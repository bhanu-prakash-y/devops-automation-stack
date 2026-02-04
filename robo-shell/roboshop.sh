#!/bin/bash

SG_ID="sg-01c5e6f682ae06599"
AMIID="ami-0220d79f3f480ecf5"


for instance in $@
do
    $(aws ec2 run-instances \
    --image-id $AMIID \
    --instance-type "t3.micro" \
    --security-group-ids $SG_ID \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
    --query 'Instances[0].PrivateIpAddress' \
    --output text)
     if [ $instance == "forntend" ]; then

         IP=$(
            aws ec2 describe-instances \
            --instance-ids $instance_id \
            --query 'Reservations[].Instances[].PublicIpAddress' \
            --output text
         )

       else 

          IP=$(
            aws ec2 describe-instances  \
            --instance-ids $instance_id \
            --query 'Reservations[].Instances[].PrivateIpAddress' \
            --output text
            
         )
         fi

done
