pipeline {
    agent any

    environment {
        VENV = '.venv'
    }
    triggers {
        pollSCM('H/5 * * * *') // Poll changes to Repo every 5mins
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/faith-nte/capstone'
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

                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
                        sh 'docker tag addressbook ibrofaith/addressbook:latest'
                        sh 'docker push ibrofaith/addressbook:latest'
                    }
                }
            }
        }

        stage('Launch Prometheus and Grafana') {
            steps {
                script {
                    echo '🚀 Launching Prometheus and Grafana...'
                    sh 'docker rm -f prometheus grafana || true'
                    sh 'docker-compose -f docker-compose.yml up -d'
                }
            }
        }

        stage('Launch Addressbook Base OS Container') {
            steps {
                sh 'docker rm -f addressbook || true'
                sh 'docker run -d --name addressbook --network monitor-net -p 8085:5000 addressbook'
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
