# Multi-stage Dockerfile: build WAR with Maven, then run on Tomcat
FROM maven:3.8.8-jdk-17 AS build
WORKDIR /workspace

# Copy project sources into container and build the WAR
COPY pom.xml ./
COPY src ./src
WORKDIR /workspace
RUN mvn -f pom.xml -pl student -am clean package -DskipTests || mvn -f pom.xml clean package -DskipTests

FROM tomcat:10.1-jdk17
# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy custom Tomcat server config to disable the shutdown port (prevents invalid shutdown commands in logs)
COPY tomcat-conf/server.xml /usr/local/tomcat/conf/server.xml
COPY tomcat-conf/start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Copy the built WAR from the builder stage
COPY --from=build /workspace/student/target/student.war /usr/local/tomcat/webapps/ROOT.war

# Set Java options
ENV JAVA_OPTS="-Dfile.encoding=UTF-8"

# Expose port
EXPOSE 8080

# Start Tomcat (use wrapper to set connector port from PORT env var)
CMD ["sh", "/usr/local/bin/start.sh"]