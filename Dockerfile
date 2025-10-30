FROM ubuntu:22.04 AS builder

RUN apt-get update && \
    apt-get install -y openjdk-21-jdk maven && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app


COPY . .


RUN mvn clean package -DskipTests -Denforcer.skip=true


FROM openjdk:21-jdk-slim

WORKDIR /app


COPY --from=builder /app/target/*.jar app.jar


EXPOSE 8080


ENTRYPOINT ["java", "-jar", "app.jar"]
