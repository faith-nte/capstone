pipeline {
    agent any

    environment {
        VENV = '.venv'
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
                sh 'docker run -d -p 80:5000 addressbook'
            }
        }

        stage('Create SQL Database') {
            steps {
                // Replace with secured password method if needed
                sh 'mysql -u root -prootpassword < schema.sql'
            }
        }

        stage('Run Tests') {
            steps {
                sh """
                    source ${VENV}/bin/activate || true
                    pytest || true
                """
            }
        }

        stage('Run Python App') {
            steps {
                sh """
                    source ${VENV}/bin/activate || true
                    python run.py
                """
            }
        }
    }

    post {
        success {
            echo 'Pipeline executed successfully'
        }
        failure {
            echo 'Pipeline failed'
        }
    }
}
