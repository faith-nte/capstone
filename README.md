# 📒 Mini Address Book App (Fullstack)

A simple app to save and show addresses.

### 🛠️ Tech Stack

- **Frontend:** HTML + Bootstrap
- **Backend:** Flask (Python)
- **Database:** MySQL + SQLAlchemy
- **Secrets:** Stored with `.env`

---

## 📁 Project Folder Structure

address-book-python/
│
├── app/
│ ├── init.py # Flask app setup
│ ├── config.py # App settings (like DB info)
│ ├── models.py # Database tables
│ ├── routes.py # Page routes
│ ├── templates/
│ │ ├── base.html # Main layout
│ │ ├── form.html # Add address form
│ │ └── display.html # Show saved addresses
│ ├── static/
│ │ └── style.css # Custom styles
│
├── venv/ # Python virtual environment
├── .env # Hidden settings (like DB password)
├── Dockerfile # Build app image
├── Dockerfile.jenkins # Jenkins image for CI/CD
├── Jenkinsfile # Jenkins pipeline script
├── docker-compose.yml # Run Grafana, Prometheus, etc.
├── entrypoint.sh # Start MySQL + Flask
├── mysql_setup.sh # Set up MySQL
├── prometheus.yml # Prometheus config
├── requirements.txt # Python packages
├── run.py # Start the app
└── schema.sql # Create DB tables

---

# 🚀 CI/CD & Monitoring

Use Jenkins, Docker, Prometheus, and Grafana to build, test, and monitor the app.

---

## ✅ What You Need First

- Docker installed
- Docker Hub login
- (Optional) Docker Compose

---

## 🔧 Steps to Set It Up

### 1. Create Jenkins Docker Image

Make a Dockerfile for Jenkins with Docker and Docker Compose inside:

```dockerfile
FROM jenkins/jenkins:lts
USER root
RUN apt-get update && \
    apt-get install -y docker.io && \
    apt-get install -y docker-compose
EXPOSE 8085 3000 9090
USER jenkins
Build the image:

sh


docker build -t jenkins-with-docker -f Dockerfile.jenkins .
2. Run Jenkins Container
Start Jenkins with ports open:

sh


docker run -it --privileged -d --name jenkins-new \
  -p 8080:8080 -p 8085:8085 -p 3000:3000 -p 9090:9090 jenkins-with-docker
3. Let Jenkins Use Docker
Go inside the Jenkins container and give Docker access:

sh


docker exec -it --user root jenkins-new bash
usermod -aG docker jenkins
newgrp docker
exit
4. Restart Jenkins
sh


docker restart jenkins-new
5. Start Docker in Jenkins
sh


docker exec -it --user root jenkins-new bash
service docker start
exit
6. Open Jenkins in Browser
Go to: http://localhost:8080

7. Get Jenkins Setup Password
Use this to log in the first time:

sh


docker exec jenkins-new cat /var/jenkins_home/secrets/initialAdminPassword
8. Add DockerHub Login to Jenkins
In Jenkins:

Go to Manage Jenkins > Manage Plugins

Install "Blue Ocean"

Go to Manage Jenkins > Credentials

Add new credential:

ID: dockerhub-credentials

Username: your DockerHub username

Password: your DockerHub password

9. Create a Jenkins Pipeline
In Jenkins:

Create new item: Addressbook

Choose Pipeline

Under pipeline settings:

Trigger: GitHub hook

Definition: Pipeline from SCM

Git repo: https://github.com/faith-nte/capstone

Branch: main

Script path: Jenkinsfile

10. Run the Pipeline
Click "Build Now" to start the pipeline.

11. Use Your App
Flask App: http://localhost:8085

Prometheus: http://localhost:9090

Grafana: http://localhost:3000

DockerHub: Check your uploaded image

📌 Extra Info
Webhook for GitHub
To test webhooks locally, use ngrok:

sh


ngrok http 8085
Use the public ngrok URL in your GitHub webhook settings.

Exposed Ports Recap
In Dockerfile.jenkins:

dockerfile


EXPOSE 8085 3000 9090
These ports let your tools (Jenkins, Flask, Grafana, Prometheus) talk to each other.

💡 Need help?
Check the docs for Jenkins, Docker, Grafana, or Prometheus — or open an issue in the GitHub repo.
```
