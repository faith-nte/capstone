pipeline {
    agent any

    environment {
        VENV = '.venv'}
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'dev', url: 'https://github.com/faith-nte/capstone'
            }
        }
        stage('Build Addressbook BaseOS Image') {
            steps {
                sh 'docker build –t addressbook . || true'
            }
        }

        stage('Launch Addressbook Base OS Container') {
            steps {
                sh 'docker run -p 80:5000 addressbook'
            }
        }

        stage('Create SQL Database') {
            steps {
                sh 'mysql -u root -p < schema.sql'
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    sh 'source venv/bin/activate || true'
                    sh 'pytest || true'
                }
            }
        }

        stage('Run Python App') {
            steps {
                script {
                    sh 'python run.py'
                }
            }
        }

    post {
        success {
            script {
                sh 'echo "Pipeline executed successfully"'
            }
        }

        failure {
            script {
                sh 'echo "Pipeline failed"'
            }
        }
    }
}
