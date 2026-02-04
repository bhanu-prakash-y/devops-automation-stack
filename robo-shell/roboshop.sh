#!/bin/bash

SG_ID="sg-01c5e6f682ae06599"
AMIID="ami-0220d79f3f480ecf5"
ZONEID="Z0726019YOHU453AVJ5U"
DOMAIN_NAME="bhanudevops.online"


for instance in $@
do
   INSTANCE_ID=$( aws ec2 run-instances \
    --image-id $AMIID \
    --instance-type "t3.micro" \
    --security-group-ids $SG_ID \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
    --query 'Instances[0].InstanceId' \
    --output text )

     if [ $instance == "forntend" ]; then

         IP=$(
            aws ec2 describe-instances \
            --instance-ids $INSTANCE_ID \
            --query 'Reservations[].Instances[].PublicIpAddress' \
            --output text
         )
          record_name="$DOMAIN_NAME"
       else 

          IP=$(
            aws ec2 describe-instances \
            --instance-ids $INSTANCE_ID \
            --query 'Reservations[].Instances[].PrivateIpAddress' \
            --output text
            record_name="$instance.$DOMAIN_NAME"
         )
        fi
            echo "IP Adress: $IP" 

            aws route53 change-resource-record-sets \
             --hosted-zone-id $ZONEID \
             --change-batch '
             {
             "Comment": "Update A record",
             "Changes": [
                 {
                   "Action": "UPSERT",
                   "ResourceRecordSet": {
                       "Name": "'$record_name'"
                        "Type": "A",
                        "TTL": 1
                        "ResourceRecords": [
                        {
                          "Value": "'$IP'"
          }
        ]
      }
    }
  ]
}
'           
             
      echo "record updated for $instance"

done
