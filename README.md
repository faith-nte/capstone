# Mini Address Book App - Fullstack App

Python (Flask) + HTML/CSS + MySQL

## Overview

This is a simple address book application.

- **Frontend:** HTML with Bootstrap
- **Backend:** Flask
- **Database:** MySQL
- **ORM:** SQLAlchemy
- **Environment Variables/Sensitive Data:** dotenv

## Project Structure

The folder structure for the app is as follows:

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
├── Dockerfile                  # To build the Docker image of the Flask app with SQL
├── Dockerfile.jenkins          # To build the Docker image of the Jenkins server for automating pipeline
├── Jenkinsfile                 # Contains the script for Jenkins pipeline
├── docker-compose.yml          # Contains instructions to run Prometheus, Grafana and define their docker network
├── entrypoint.sh               # Script to start MySQL service, activate Python venv, and run the app
├── mysql_setup.sh              # Script to install MySQL, configure and change root password from default
├── prometheus.yml              # Configure the parameters and scraping information for Prometheus
├── requirements.txt            # Dependencies for the project
├── run.py                      # Main entry point to run the Flask app
└── schema.sql                  # SQL script for creating the database and tables
```

---

# CI/CD Pipeline & Monitoring Setup

This section provides the step-by-step process for automating the build, deployment, logging, and monitoring of the Address Book app using Jenkins, Docker, Prometheus, and Grafana.

---

## Prerequisites

- Docker must be installed on the host machine.
- Docker Hub credentials (to push the app image).
- [Optional] Docker Compose if you wish to extend beyond this guide.

---

## Step-by-Step Process

### 1. Build Jenkins Docker Image

Create a Jenkins image with Docker and Docker Compose installed. Expose the following ports:

- **9090**: Prometheus
- **3000**: Grafana
- **8085**: Flask App

**Create `Dockerfile.jenkins`:**

```Dockerfile
FROM jenkins/jenkins:lts
USER root
RUN apt-get update && \
    apt-get install -y docker.io && \
    apt-get install -y docker-compose
EXPOSE 8085 3000 9090
USER jenkins
```

**Build the Docker image:**

```sh
docker build -t jenkins-with-docker -f Dockerfile.jenkins .
```

---

### 2. Run the Jenkins Container

Run the Docker container with Jenkins and map the required ports:

```sh
docker run -it --privileged -d --name jenkins-new \
  -p 8080:8080 -p 8085:8085 -p 3000:3000 -p 9090:9090 jenkins-with-docker
```

---

### 3. Grant Jenkins User Docker Access

Connect to the container as root and add Jenkins user to the Docker group:

```sh
docker exec -it --user root jenkins-new bash
usermod -aG docker jenkins
newgrp docker
exit
```

---

### 4. Restart the Jenkins Container

Restart the container to apply group changes:

```sh
docker restart jenkins-new
```

---

### 5. Start Docker Service in the Container

Start Docker inside the Jenkins container:

```sh
docker exec -it --user root jenkins-new bash
service docker start
exit
```

---

### 6. Access Jenkins UI

Open Jenkins in your browser at [http://localhost:8080](http://localhost:8080).

---

### 7. Get Jenkins Initial Admin Password

Retrieve the Jenkins setup password:

```sh
docker exec jenkins-new cat /var/jenkins_home/secrets/initialAdminPassword
```

Use this password in your browser to complete Jenkins setup.

---

### 8. Set Up Jenkins DockerHub Credentials

- In Jenkins: go to **Manage Jenkins > Manage Plugins**
- Add Blue Ocean plugin to see enhanced GUI for the pipeline
- In Jenkins: go to **Manage Jenkins > Manage Credentials**
- Add a new credential:
  - **ID:** `dockerhub-credentials`
  - **Username:** Your DockerHub username
  - **Password:** Your DockerHub password

---

### 9. Create and Configure Jenkins Pipeline

- In Jenkins, create a new build item:

  - **Name:** Addressbook
  - **Type:** Pipeline

- Configure the pipeline:
  - **Build Triggers:** GitHub hook trigger for GITScm polling
  - **Pipeline Definition:** Pipeline script from SCM
  - **SCM Type:** Git
  - **Repository URL:** `https://github.com/faith-nte/capstone`
  - **Branch Specifier:** `main`
  - **Script Path:** `Jenkinsfile`

---

### 10. Build the Project

Click **"Build Now"** in Jenkins to trigger your pipeline.

---

### 11. Access Your Services

- **Flask App:** [http://localhost:8085](http://localhost:8085)
- **Prometheus:** [http://localhost:9090](http://localhost:9090)
- **Grafana:** [http://localhost:3000](http://localhost:3000)
- **DockerHub:** Find the application image in your DockerHub repo.

---

**For troubleshooting or more details, see the documentation for each tool or raise an issue in this repo.**

---

//### 12. Upcoming - Expose localhost with ngrok

---

not yet happy Happy Building!

will be soon...

not still....

not still.
