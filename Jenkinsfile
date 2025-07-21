pipeline {
  agent {
    kubernetes {
      yamlFile 'jenkins-agent.yaml'
    }
  }

  environment {
    DOCKER_IMAGE = "atatara/flask-app:${env.BUILD_NUMBER}"
    APP_DIR     = "app/flask-app"
    TELEGRAM_BOT_TOKEN = credentials('TELEGRAM_BOT_TOKEN') // Secret text credential in Jenkins
    TELEGRAM_CHAT_ID = '239608115' // твой chat id
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
          withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
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
            helm upgrade --install flask-app ./helm/flask-app \
              --namespace devops-tools \
              --set image.repository=atatara/flask-app \
              --set image.tag=${BUILD_NUMBER}
          '''
        }
      }
    }
  }

  post {
    success {
      script {
        sh """
          curl -s -X POST https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage \
          -d chat_id=${TELEGRAM_CHAT_ID} \
          -d text='Jenkins pipeline #${env.BUILD_NUMBER} SUCCESSFUL for ${env.JOB_NAME}'
        """
      }
    }
    failure {
      script {
        sh """
          curl -s -X POST https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage \
          -d chat_id=${TELEGRAM_CHAT_ID} \
          -d text='Jenkins pipeline #${env.BUILD_NUMBER} FAILED for ${env.JOB_NAME}'
        """
      }
    }
  }
}

