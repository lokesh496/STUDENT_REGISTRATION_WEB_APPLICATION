# Use Tomcat with JDK 17
FROM tomcat:10.1-jdk17

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file to webapps
COPY target/student.war /usr/local/tomcat/webapps/ROOT.war

# Set PostgreSQL environment variables (these will override defaults in code)
ENV DB_URL="jdbc:postgresql://ep-curly-art-a456yhbk-pooler.us-east-1.aws.neon.tech/neondb?sslmode=require&channel_binding=require"
ENV DB_USER="neondb_owner"
ENV DB_PASSWORD="npg_KpDh4oXLFAG8"
ENV DB_DRIVER="org.postgresql.Driver"
ENV JAVA_OPTS="-Dfile.encoding=UTF-8"

# Expose port
EXPOSE 8080

# Start Tomcat with environment variables
CMD ["catalina.sh", "run"]