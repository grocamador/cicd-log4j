FROM tomcat:8.0.36-jre8
USER root
RUN rm -rf /usr/local/tomcat/webapps/*
ADD vulnerable-application/target/log4shellcustom-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080 
CMD ["catalina.sh", "run"]
