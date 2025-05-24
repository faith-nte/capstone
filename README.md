# Mini Address Book App - Fullstack App
Python(Flask) + HTML/CSS + MySQL

## Overview

This is a simple address book application. 

 - **Frontend:** HTML with Bootstrap
 - **Backend:** Flask
 - **Database:** MySQL
 - **ORM:** SQLAlchemy
 - **Envvironemnt Variables/Sensitive Data:** dotenv


## Project Structure

Here’s the folder structure for the app:

```
address-book-python/
│
├── app/
│   ├── __init__.py             # Flask app and configuration setup
│   ├── config.py               # Configuration file (DB details, hidden using .env)
│   ├── models.py               # Database schema
│   ├── routes.py               # Routes for input and display pages
│   ├── templates/              # HTML templates for the app
│   │   ├── base.html           # Base template with navigation bar
│   │   ├── form.html           # Input form template
│   │   └── display.html        # Display template for submitted data
│   ├── static/                 # Static files (e.g., CSS)
│   │   └── style.css           # Custom styles for the app
│
├── venv/                       # Virtual environment folder
├── .env                        # Environment variables (e.g., DB password)
├── requirements.txt            # Dependencies for the project
├── run.py                      # Main entry point to run the Flask app
└── schema.sql                  # SQL script for creating the database and tables

---

# AddressBook App CI/CD Pipeline

This pipeline automates the **build, deployment, logging, and monitoring** of a Python Flask AddressBook application running in a Docker container. It uses Jenkins for automation and incorporates Prometheus and Grafana for monitoring.

## Prerequisites

- **Docker** must be installed on the host machine.
- **Docker Hub** credentials are required (to push the app image).
- [Optional] **Docker Compose** if you wish to extend beyond this guide.

---

## Step-by-Step Setup

### 1. Build Jenkins Docker Image

Create a Jenkins image with Docker and Docker Compose installed, and expose the necessary ports:

- **9090:** Prometheus
- **3000:** Grafana
- **8085:** Flask App

#### Create `Dockerfile.jenkins`:

```Dockerfile
FROM jenkins/jenkins:lts
USER root
RUN apt-get update && \
    apt-get install -y docker.io && \
    apt-get install -y docker-compose
EXPOSE 8085 3000 9090
USER jenkins
```

#### Build the Docker Image:

```bash
docker build -t jenkins-with-docker -f Dockerfile.jenkins .
```

---

### 2. Run the Jenkins Container

Start the new Jenkins container with Docker privileges and map the required ports:

```bash
docker run -it --privileged -d --name jenkins-new \
  -p 8080:8080 -p 8085:8085 -p 3000:3000 -p 9090:9090 jenkins-with-docker
```

---

### 3. Grant Jenkins User Docker Access

Connect to the container as root and add the Jenkins user to the Docker group:

```bash
docker exec -it --user root jenkins-new bash
usermod -aG docker jenkins
newgrp docker
exit
```

---

### 4. Restart the Jenkins Container

Restart the container so the group permissions take effect:

```bash
docker restart jenkins-new
```

---

### 5. Start Docker Service in Container

Start Docker in the container (run these as root):

```bash
docker exec -it --user root jenkins-new bash
service docker start
exit
```

---

### 6. Access Jenkins UI

Visit [http://localhost:8080](http://localhost:8080) on your host machine to access Jenkins.

---

### 7. Get Jenkins Initial Admin Password

Retrieve the Jenkins setup password:

```bash
docker exec jenkins-new cat /var/jenkins_home/secrets/initialAdminPassword
```

Use this password to unlock Jenkins in your browser and follow the setup wizard.

---

### 8. Set Up Jenkins DockerHub Credentials

- In Jenkins: go to **Manage Jenkins > Manage Credentials**
- Add a new credential:
    - **ID:** `dockerhub-credentials`
    - **Username:** Your DockerHub username
    - **Password:** Your DockerHub password

---

### 9. Create and Configure Jenkins Pipeline

- Go to Jenkins and create a new build item:
  - **Name:** Addressbook
  - **Type:** Pipeline
- Configure pipeline:
  - **Build Triggers:** GitHub hook trigger for GITScm polling
  - **Pipeline Definition:** Pipeline script from SCM
  - **SCM Type:** Git
  - **Repository URL:** `https://github.com/faith-nte/capstone`
  - **Branch Specifier:** `main`
  - **Script Path:** `Jenkinsfile`
- Save the configuration

---

### 10. Build the Project

Click **"Build Now"** in Jenkins to start your pipeline.

---

### 11. Access Services

- **Flask App:** [http://localhost:8085](http://localhost:8085)
- **Prometheus:** [http://localhost:9090](http://localhost:9090)
- **Grafana:** [http://localhost:3000](http://localhost:3000)
- **DockerHub:** The application image will be available in your DockerHub repository.

---

## Summary

This README describes how to set up a full CI/CD pipeline for your Flask AddressBook app, with monitoring and automated deployment. For troubleshooting or extensions, refer to the individual tool documentation or the repository’s Issues section.

---

**Happy Building!**
