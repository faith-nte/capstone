pipeline {
    agent any

    environment {
        VENV = '.venv'
    }
}

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'dev', url: 'https://github.com/faith-nte/capstone'
            }
        }

        stage('Build Addressbook BaseOS Image') {
            steps {
                sh 'docker build -t addressbook . || true'
            }
        }

        stage('Launch Addressbook Base OS Container') {
            steps {
                sh 'docker run -d --name addressbook -p 80:5000 addressbook'
            }
        }

    post {
        success {
            echo '✅ Pipeline executed successfully'
        }

        failure {
            sh 'docker stop addressbook && docker rm addressbook'
            echo '❌ Pipeline failed'
        }
    }
}
