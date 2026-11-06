FROM eclipse-temurin:17-jdk AS compilation

WORKDIR /app

COPY src/main/ src/main/

RUN mkdir -p out && javac -d out $(find src/main -name "*.java")

FROM eclipse-temurin:17-jre

WORKDIR /app

COPY --from=compilation /app/out /app/out

ENTRYPOINT ["java", "-cp", "/app/out", "fr.nanterre.vehicules.GestionVehiculeInconnue"]
