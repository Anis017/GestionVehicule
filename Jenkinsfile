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
    }
    post {
        success { echo 'VALIDATION REUSSIE : compilation et tests OK' }
        failure { echo 'VALIDATION ECHOUEE : consulter Console Output' }
    }
}

