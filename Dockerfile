# Base image:Tomcat v8.0
FROM tomcat:latest

# Copy war file from target to tomcat directory inside docker container
COPY target/java-web-app*.war /usr/local/tomcat/webapps/java-web-app.war
