#! /bin/bash
docker build -t rishi:01 .
echo "build completed"
docker tag rishi:01 rishikoy/rishi01
docker rm -f rishi
docker run -d --name rishi -p 8888:8080 rishikoy/rishi01 bash
echo "builded tag with docker id"
docker push rishikoy/rishi01
#docker run -d --rm --name rishi -p 8888:8080 rishikoy/rishi01 bash
#docker login
#rishikoy
#passwordrishi
