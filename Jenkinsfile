
pipeline {
    agent any

    environment {
        VENV = '.venv'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/Ibrocold/devboot02-ab'
            }
        }

        stage('Build Addressbook BaseOS Image') {
            steps {
                sh 'docker build -t addressbook . || true'
            }
        }

        stage('Push Addressbook BaseOS Image to Docker Hub') {
            steps {
                script {
                    echo '🚀 Tagging and pushing Docker image to Docker Hub...'

                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                        sh 'docker tag addressbook ibrocold/addressbook:latest'
                        sh 'docker push ibrocold/addressbook:latest'
                    }
                }
            }
        }

        stage('Launch Addressbook Base OS Container') {
            steps {
                sh 'docker rm -f addressbook || true'
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
