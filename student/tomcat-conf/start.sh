#!/bin/sh
# Replace PORT_PLACEHOLDER in server.xml with the PORT env var (default 8080)
: "${PORT:=8080}"
if [ -f /usr/local/tomcat/conf/server.xml ]; then
  sed -i "s/PORT_PLACEHOLDER/${PORT}/g" /usr/local/tomcat/conf/server.xml
fi
echo "--- Effective /usr/local/tomcat/conf/server.xml ---"
cat /usr/local/tomcat/conf/server.xml || true
echo "--- End server.xml ---"

echo "Starting Tomcat (binding to PORT=${PORT})"
exec catalina.sh run
