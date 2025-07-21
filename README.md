# Task 6 – Application Deployment via Jenkins Pipeline

This repository contains a complete CI/CD pipeline for a Flask web application. The pipeline is managed by Jenkins and includes code analysis with SonarQube, testing, Docker image building and pushing, and deployment via Helm to Kubernetes.

##  Project Structure
.
├── app

│ └── flask-app

│ ├── Dockerfile

│ ├── requirements.txt

│ └── ...

├── helm

│ └── flask-app

│ ├── Chart.yaml

│ ├── values.yaml

│ └── templates/

├── jenkins-agent.yaml

└── Jenkinsfile

## Jenkins Pipeline Stages

The `Jenkinsfile` defines the following stages:

1. **Checkout**
   - Clones the GitHub repository into the Jenkins workspace.

2. **SonarQube Analysis**
   - Runs `sonar-scanner` to analyze code quality using SonarQube.
   - Requires `SONAR_TOKEN` stored in Jenkins as a Kubernetes secret.

3. **Run Tests**
   - Installs dependencies and runs tests using `pytest` and `coverage`.
   - Generates `report.xml` and `coverage.xml` for test results and coverage.

4. **Build Docker Image**
   - Builds a Docker image using the `Dockerfile` from the Flask app directory.

5. **Push Docker Image**
   - Pushes the built image to Docker Hub using credentials from Jenkins (`dockerhub-credentials`).
   - Image is tagged with the Jenkins `BUILD_NUMBER`.

6. **Deploy with Helm**
   - Deploys the application to a Kubernetes cluster using Helm charts located in `helm/flask-app`.

## Plugins and apps used

- Jenkins (running in Kubernetes)
- SonarQube
- Docker
- Helm
- Python / Flask
- Pytest & Coverage

## Docker

Each build creates a Docker image with the tag:

`docker.io/atatara/flask-app:${BUILD_NUMBER}`

##  SonarQube

Make sure SonarQube is accessible from Jenkins and a token is provided via Kubernetes secret `sonarqube-token` under key `SONAR_TOKEN`.

##  Jenkins Credentials

- **dockerhub-credentials** – Docker Hub username and password
- **sonarqube-token** – Token for SonarQube (via Kubernetes secret)

## Telegram Notifications (optional)

The pipeline supports Telegram notifications. You can configure:

- Bot token
- Chat ID

Using the `Telegram Bot` plugin in Jenkins and environment variables.

##  Running Tests

Tests are located in the Flask app directory and executed using:

```bash
pytest --junitxml=report.xml --cov=. --cov-report=xml
