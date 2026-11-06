pipeline {
    agent any
    stages {
        stage('Informations Git') {
            steps {
                sh 'git log -1 --oneline'
            }
        }
        stage('Compilation Java') {
            steps {
                sh 'mkdir -p out'
                sh 'javac -d out $(find src/main -name "*.java")'
            }
        }
        stage('Tests JUnit') {
            steps {
                sh 'chmod +x test.sh'
                sh './test.sh'
            }
        }
        stage('Construction image Docker') {
            steps {
                sh 'docker build -t gestionvehicule:ci-${BUILD_NUMBER} .'
            }
        }
        stage('Verification conteneur') {
            steps {
                sh 'docker run --rm gestionvehicule:ci-${BUILD_NUMBER}'
            }
        }
    }
    post {
        success { echo 'CI REUSSIE: tests et execution Docker OK' }
        failure { echo 'CI ECHOUEE: consulter les journaux Jenkins' }
    }
}
