# Pull base image 
From tomcat:8-jre8 

# Maintainer 
COPY ./*.war /usr/local/tomcat/webapps
