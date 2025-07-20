pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
metadata:
  namespace: devops-tools
spec:
  containers:
  - name: docker
    image: docker:25.0.3-dind
    command:
    - cat
    tty: true
    securityContext:
      privileged: true
  - name: helm
    image: alpine/helm:3.14.3
    command:
    - cat
    tty: true
  - name: jnlp
    image: jenkins/inbound-agent:alpine
    args: ['\$(JENKINS_SECRET)', '\$(JENKINS_NAME)']
"""
    }
  }

  environment {
    DOCKER_IMAGE = 'atatara/rsschool-flask'
    APP_DIR = 'app/flask-app'
    HELM_DIR = 'helm/flask-app'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Docker image') {
      steps {
        container('docker') {
          dir("${APP_DIR}") {
            sh 'dockerd-entrypoint.sh &'
            sh 'sleep 10'
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
        container('helm') {
          dir("${HELM_DIR}") {
            sh 'helm upgrade --install flask-app . --set image.repository=$DOCKER_IMAGE'
          }
        }
      }
    }
  }
}

