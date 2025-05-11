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
                sh 'docker run -d --name addressbooks -p 81:5000 addressbook'
            }
        }

        stage('Install MySQL Server in Container') {
            steps {
                sh '''
                docker exec addressbooks apt-get update
                docker exec addressbooks apt-get install -y mysql-server
                docker exec addressbooks service mysql start
                '''
            }
        }

        stage('Set MySQL Root Password') {
            steps {
                sh '''
                docker exec addressbooks sh -c "mysql -u root <<EOF
                ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'yourpassword';
                FLUSH PRIVILEGES;
                EOF"
                '''
            }
        }

        stage('Create SQL Database') {
            steps {
                sh '''
                docker cp schema.sql addressbooks:/tmp/schema.sql
                docker exec addressbooks mysql -u root -pyourpassword < /tmp/schema.sql
                '''
            }
        }

        stage('Run Tests') {
            steps {
                sh '''
                docker exec addressbooks sh -c "source ${VENV}/bin/activate && pytest || true"
                '''
            }
        }

        stage('Run Python App') {
            steps {
                sh '''
                docker exec addressbooks sh -c "source ${VENV}/bin/activate && python run.py"
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline executed successfully'
        }

        failure {
            echo '❌ Pipeline failed'
        }
    }
}
