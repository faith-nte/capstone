pipeline {
    agent any

    environment {
        VENV = '.venv'
        DOCKER_IMAGE = 'ibrocold/addressbook:latest'
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
                sh 'docker run --rm -d --name addressbook -p 8085:5000 addressbook'
            }
        }

        stage('Push Addressbook Running App Image to Docker Hub') {
            steps {
                script {
                    sh 'docker commit addressbook addressbook-snapshot'
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-credentials') {
                        sh "docker tag addressbook-snapshot ${DOCKER_IMAGE}"
                        sh "docker push ${DOCKER_IMAGE}"
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
