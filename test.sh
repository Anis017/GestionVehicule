#!/bin/sh
# Compile le code et les tests, puis lance les tests JUnit
JUNIT=/usr/share/java/junit-platform-console-standalone.jar
rm -rf out
javac -d out -cp "$JUNIT" $(find src -name "*.java") || exit 1
java -jar "$JUNIT" execute --disable-banner --disable-ansi-colors \
     -cp out --select-package fr.nanterre.vehicules
