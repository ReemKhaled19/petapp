# ════════════════════════════════════════════════════════════
# Stage 1: Build JAR with Maven
# ════════════════════════════════════════════════════════════
FROM ubuntu:22.04 AS builder

# ثبّت Java 21 و Maven
RUN apt-get update && \
    apt-get install -y openjdk-21-jdk maven && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# نسخ كل الملفات
COPY . .

# بناء المشروع
RUN mvn clean package -DskipTests -Denforcer.skip=true

# ════════════════════════════════════════════════════════════
# Stage 2: Runtime with OpenJDK 21
# ════════════════════════════════════════════════════════════
FROM openjdk:21-jdk-slim

WORKDIR /app

# نسخ الـ JAR من الـ builder
COPY --from=builder /app/target/*.jar app.jar

# تحديد البورت
EXPOSE 8080

# نقطة تشغيل الحاوية
ENTRYPOINT ["java", "-jar", "app.jar"]
