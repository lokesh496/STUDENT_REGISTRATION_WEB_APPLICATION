# Multi-stage build: build the WAR with Maven, then run in Tomcat
FROM maven:3.9.2-eclipse-temurin-11 AS build
WORKDIR /workspace
COPY pom.xml ./
COPY src ./src
RUN mvn -B package -DskipTests

FROM tomcat:9.0-jdk11
ENV CATALINA_HOME /usr/local/tomcat
ENV TZ UTC

# Copy the built WAR into Tomcat as ROOT.war so app is served at /
COPY --from=build /workspace/target/student.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
