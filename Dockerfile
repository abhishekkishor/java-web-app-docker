FROM tomcat:8.0.20-jre8

# Copy war file from target to tomcat directory inside docker container
COPY target/java-web-app*.war /usr/local/tomcat/webapps/java-web-app.war
