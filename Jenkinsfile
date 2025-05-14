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
                    // Build the Docker image, and fail the pipeline if it doesn't build
                    sh 'docker build -t addressbook .'
                }
            }
        }

        stage('Launch Addressbook Base OS Container') {
            steps {
                script {
                    // Stop any running container with the same name to avoid conflict
                    sh 'docker rm -f addressbook || true'

                    // Run the container
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
                // Ensure container is cleaned up on failure
                sh 'docker rm -f addressbook || true'
            }
            echo '❌ Pipeline failed'
        }
    }
}
