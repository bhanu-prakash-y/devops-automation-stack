#!bin/bash

NUMBER=$1

# -gt -> greater than
# -lt -> less than
# -eq -> equal
# -ne -> not equal

if [ $NUMBER -gt 150 ]; then
    echo "give number: $NUMBER is greater than 150"

 else
     echo "give number: $NUMBER is less than 150"
fi