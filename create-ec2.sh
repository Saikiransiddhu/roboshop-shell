#!/bin/bash

NAMES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "web")

for i in "${NAMES[@]}"
do 
    echo "NAME: $i"
done
#create