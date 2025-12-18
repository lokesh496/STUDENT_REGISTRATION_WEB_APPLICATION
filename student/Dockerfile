# Use Tomcat with JDK 17
FROM tomcat:10.1-jdk17

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file to webapps
COPY target/student.war /usr/local/tomcat/webapps/ROOT.war

# Set Java options
ENV JAVA_OPTS="-Dfile.encoding=UTF-8"

# Expose port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]