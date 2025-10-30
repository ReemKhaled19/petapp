# Stage 1: Build with Maven + JDK 21 (خفيف)
# نستخدم صورة Maven الرسمية المبنية على temurin 21
FROM maven:3.9-eclipse-temurin-25 AS builder

# تحديد مجلد العمل
WORKDIR /app

# نسخ ملفات الـ build أولاً للاستفادة من الكاش
COPY pom.xml .
RUN mvn -B dependency:go-offline

# نسخ باقي كود المصدر
COPY src ./src

# بناء المشروع وتخطي الاختبارات
RUN mvn -q -e -DskipTests -Denforcer.skip=true clean package

# ---

# Stage 2: Runtime JRE فقط (أخف)
# نستخدم صورة JRE فقط لأننا لا نحتاج JDK كامل للتشغيل
FROM eclipse-temurin:25-jre-jammy-ea

WORKDIR /app

# نسخ ملف الـ JAR فقط من الـ builder
COPY --from=builder /app/target/*.jar app.jar

# تحديد البورت
EXPOSE 8080

# نقطة تشغيل الحاوية
ENTRYPOINT ["java","-jar","app.jar"]


