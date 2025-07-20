pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
metadata:
  namespace: devops-tools
spec:
  dnsPolicy: ClusterFirst
  containers:
  - name: docker
    image: docker:25.0.3-dind
    securityContext:
      privileged: true
    command:
      - sh
      - -c
      - |
        dockerd-entrypoint.sh &
        sleep 5
        tail -f /dev/null
    tty: true
    volumeMounts:
      - mountPath: /home/jenkins/agent
        name: workspace-volume
  - name: jnlp
    image: atatara/jenkins-agent-sonar:latest
    args: ['\$(JENKINS_SECRET)', '\$(JENKINS_NAME)']
  volumes:
  - name: workspace-volume
    emptyDir: {}
"""
    }
  }

  environment {
    DOCKER_IMAGE = 'atatara/rsschool-flask'
    APP_DIR = 'app/flask-app'
    HELM_DIR = 'helm/flask-app'
    SONAR_PROJECT_KEY = 'rsschool-flask'
    SONAR_HOST_URL = 'http://sonarqube-sonarqube.devops-tools.svc.cluster.local:9000'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }
    stage('SonarQube Analysis') {
      steps {
        withCredentials([string(credentialsId: 'sonarqube-token', variable: 'SONAR_TOKEN')]) {
          dir("${APP_DIR}") {
            sh '''
              echo "Checking DNS availability of SonarQube..."
              nslookup sonarqube-sonarqube.devops-tools.svc.cluster.local

              echo "Checking HTTP availability of SonarQube..."
              curl -sSf $SONAR_HOST_URL

              echo "Starting SonarScanner..."
              sonar-scanner \
                -Dsonar.projectKey=$SONAR_PROJECT_KEY \
                -Dsonar.sources=. \
                -Dsonar.host.url=$SONAR_HOST_URL \
                -Dsonar.login=$SONAR_TOKEN
            '''
          }
        }
      }
    }

    stage('Build Docker image') {
      steps {
        container('docker') {
          dir("${APP_DIR}") {
            sh 'docker build -t $DOCKER_IMAGE .'
          }
        }
      }
    }
    stage('Push Docker image') {
      steps {
        container('docker') {
          withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
            script {
              sh 'echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USER --password-stdin'
              sh 'docker push $DOCKER_IMAGE'
            }
          }
        }
      }
    }

    stage('Deploy with Helm') {
      steps {
        dir("${HELM_DIR}") {
          sh 'helm upgrade --install flask-app . --set image.repository=$DOCKER_IMAGE'
        }
      }
    }
  }
}

