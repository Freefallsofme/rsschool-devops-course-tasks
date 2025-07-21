pipeline {
  agent {
    kubernetes {
      yamlFile 'jenkins-agent.yaml'
    }
  }

  environment {
    DOCKER_IMAGE = "atatara/flask-app:${env.BUILD_NUMBER}"
    APP_DIR = "app/flask-app"
  }

  stages {
    stage('Checkout') {
      steps {
        container('jnlp') {
          checkout scm
        }
      }
    }

    stage('SonarQube Analysis') {
      steps {
        container('sonar') {
          withSonarQubeEnv('SonarQube') {
            dir("${APP_DIR}") {
              sh 'sonar-scanner'
            }
          }
        }
      }
    }

    stage('Run tests') {
      steps {
        container('python') {
          dir("${APP_DIR}") {
            sh '''
              pip install -r requirements.txt
              pip install pytest coverage
              coverage run -m pytest --junitxml=report.xml
              coverage xml -o coverage.xml
            '''
          }
        }
      }
    }

    stage('Build Docker image') {
      steps {
        container('docker') {
          dir("${APP_DIR}") {
            sh "docker build -t ${DOCKER_IMAGE} ."
          }
        }
      }
    }

    stage('Push Docker image') {
      steps {
        container('docker') {
          withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
            sh '''
              echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
              docker push ${DOCKER_IMAGE}
            '''
          }
        }
      }
    }

    stage('Deploy with Helm') {
      steps {
        container('helm') {
          sh '''
            helm upgrade --install flask-app helm-chart/flask-app \
              --namespace devops-tools \
              --set image.repository=atatara/flask-app \
              --set image.tag=${BUILD_NUMBER}
          '''
        }
      }
    }
  }
}

