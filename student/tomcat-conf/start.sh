#!/bin/sh
# Replace PORT_PLACEHOLDER in server.xml with the PORT env var (default 8080)
: "${PORT:=8080}"
if [ -f /usr/local/tomcat/conf/server.xml ]; then
  sed -i "s/PORT_PLACEHOLDER/${PORT}/g" /usr/local/tomcat/conf/server.xml
fi
exec catalina.sh run
