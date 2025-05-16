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
                script {
                    echo '📦 Building Docker image...'
                    sh 'docker build -t addressbook .'
                }
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
                script {
                    echo '🧪 Launching Docker container...'

                    // Clean up any existing container
                    sh 'docker rm -f addressbook || true'

                    // Run the container in the background
                    sh 'docker run -d --name addressbook -p 8085:5000 addressbook'
                }
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline executed successfully'
        }

        failure {
            script {
                // Clean up container on failure
                sh 'docker rm -f addressbook || true'
            }
            echo '❌ Pipeline failed'
        }
    }
}
