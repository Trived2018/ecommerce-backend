# Multi-stage Docker build for Spring Boot (Java 17)
FROM maven:3.9.9-eclipse-temurin-17 AS builder
WORKDIR /app

# Cache dependencies first for faster rebuilds
COPY pom.xml .
RUN mvn -q -DskipTests dependency:go-offline

# Copy source and build jar
COPY src ./src
COPY .mvn ./.mvn
COPY mvnw mvnw
COPY mvnw.cmd mvnw.cmd
RUN mvn -q -DskipTests clean package

FROM eclipse-temurin:17-jre
WORKDIR /app

# Copy built artifact
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8081
ENTRYPOINT ["java", "-Dserver.port=8081", "-jar", "app.jar"]
