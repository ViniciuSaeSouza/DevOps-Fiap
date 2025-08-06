FROM maven:3.9.5-eclipse-temurin-17
WORKDIR /app
COPY .. /app
RUN mvn clean package -DskipTests
EXPOSE 8080
CMD ["java", "-jar","target/spring-boot-complete-0.0.1-SNAPSHOT.jar"]
