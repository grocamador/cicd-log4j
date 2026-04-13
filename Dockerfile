# Build stage
FROM openjdk:8-jdk-alpine AS builder
WORKDIR /app
COPY . .
RUN apk add --no-cache maven
RUN cd vulnerable-application && mvn clean package

# Runtime stage
FROM openjdk:8-jre-alpine
RUN apk add --no-cache curl
WORKDIR /app

# Download and install Tomcat
RUN curl -O https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.96/bin/apache-tomcat-8.5.96.tar.gz && \
    tar -xzf apache-tomcat-8.5.96.tar.gz && \
    mv apache-tomcat-8.5.96 tomcat && \
    rm apache-tomcat-8.5.96.tar.gz && \
    rm -rf tomcat/webapps/*

# Copy WAR file from builder
COPY --from=builder /app/vulnerable-application/target/log4shellcustom-1.0-SNAPSHOT.war /app/tomcat/webapps/ROOT.war

EXPOSE 8080
WORKDIR /app/tomcat
CMD ["./bin/catalina.sh", "run"]
