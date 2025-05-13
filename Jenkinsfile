pipeline {
    agent any

    environment {
        VENV = '.venv'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/faith-nte/capstone'
            }
        }

        stage('Build Addressbook BaseOS Image') {
            steps {
                sh 'docker build -t addressbook .'
            }
        }

        stage('Launch Addressbook Base OS Container') {
            steps {
                sh 'docker run -d --name addressbook -p 8085:5000 addressbook'
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline executed successfully'
        }

        failure {
            script {
                sh 'docker stop addressbook || true'
                sh 'docker rm addressbook || true'
            }
            echo '❌ Pipeline failed'
        }
    }
}
