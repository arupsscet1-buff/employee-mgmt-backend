# =========================
# Builder
# =========================
FROM eclipse-temurin:17-jdk AS builder

WORKDIR /application

COPY target/spring-boot-backend-*.jar application.jar

RUN java -Djarmode=layertools -jar application.jar extract


# =========================
# Runtime
# =========================
FROM eclipse-temurin:17-jre

WORKDIR /application

RUN useradd --system --create-home --uid 1001 spring

COPY --from=builder /application/dependencies/ ./
COPY --from=builder /application/spring-boot-loader/ ./
COPY --from=builder /application/snapshot-dependencies/ ./
COPY --from=builder /application/application/ ./

USER 1001

EXPOSE 3100

ENTRYPOINT ["java", "org.springframework.boot.loader.launch.JarLauncher"]