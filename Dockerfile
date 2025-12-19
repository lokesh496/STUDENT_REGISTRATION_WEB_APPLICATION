# Multi-stage Dockerfile: build WAR with Maven then run on Tomcat
FROM maven:3.8.8-openjdk-17 AS build
WORKDIR /workspace

# Copy student project sources and build the WAR
COPY student/pom.xml student/
COPY student/src student/src
WORKDIR /workspace/student
RUN mvn clean package -DskipTests

FROM tomcat:10.1-jdk17
# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the built WAR from the builder stage
COPY --from=build /workspace/student/target/student.war /usr/local/tomcat/webapps/ROOT.war

# Do NOT hardcode secrets in the Dockerfile. Provide DB credentials via Render env vars.
# Example envs to set on Render: DB_URL, DB_USER, DB_PASSWORD, DB_DRIVER
ENV DB_URL=jdbc:postgresql://ep-curly-art-a456yhbk-pooler.us-east-1.aws.neon.tech/neondb?sslmode=require&channelBinding=require
ENV DB_USER=neondb_owner
ENV DB_DRIVER=org.postgresql.Driver

# Expose port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]