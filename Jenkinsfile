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

        stage('Push Addressbook Running App Image to Docker Hub') {
            steps {
                script {
                    // Commit the running container to a new image
                    sh 'docker commit addressbook addressbook-snapshot'

                    // Push to Docker Hub with authentication
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                        def image = docker.image('ibrocold/addressbook')

                        // Tag the local snapshot image
                        sh 'docker tag addressbook-snapshot ibrocold/addressbook:latest'

                        // Push the image
                        image.push('latest')
                    }
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
                sh 'docker stop addressbook || true'
                sh 'docker rm addressbook || true'
            }
            echo '❌ Pipeline failed'
        }
    }
}
