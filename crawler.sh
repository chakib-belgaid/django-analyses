#!/bin/bash 

sudo chown -R spirals pgdata 

docker-compose build 


docker-compose up -d sqlite


for i in {1..30} ; do 
    print $i
    curl http://localhost:3034/fullstack/events/optimized/  >> /dev/null
    sleep 1 
    curl http://localhost:3034/fullstack/events/prefetch/  >> /dev/null
    sleep 1 
    curl http://localhost:3034/fullstack/events/naive/  >> /dev/null
    sleep 1 
    done 

docker-compose down --rmi all

docker-compose up -d postgres

for i in {1..30} ; do 
    print $i
    curl http://localhost:3035/fullstack/events/optimized/  >> /dev/null
    sleep 1 
    curl http://localhost:3035/fullstack/events/prefetch/  >> /dev/null
    sleep 1 
    curl http://localhost:3035/fullstack/events/naive/  >> /dev/null
    sleep 1 
    done 

docker-compose down --rmi all