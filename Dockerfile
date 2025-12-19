# Multi-stage Dockerfile: build WAR with Maven then run on Tomcat
FROM maven:3.8.8-jdk-17 AS build
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

# Set environment variables (use Render env vars in dashboard instead of hardcoding)
ENV DB_URL=jdbc:postgresql://ep-curly-art-a456yhbk-pooler.us-east-1.aws.neon.tech/neondb?sslmode=require&channel_binding=require
ENV DB_USER=neondb_owner
ENV DB_PASSWORD=npg_KpDh4oXLFAG8
ENV DB_DRIVER=org.postgresql.Driver

# Expose port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]