pipeline {
  agent any

  environment {
    REGISTRY    = 'docker.io/atatara'
    IMAGE_NAME  = "${REGISTRY}/flask-app"
    CHART_PATH  = 'helm/flask-app'
    NAMESPACE   = 'default'
    SONARQUBE   = 'MySonarQube'      // имя SonarQube-сервера в Jenkins
    CRED_DOCKER = 'docker-hub-creds' 
    CRED_KUBE   = 'kubeconfig-cred'  // ID Jenkins‑креденшиала с kubeconfig
  }

  triggers {
    // Если у вас Multibranch Pipeline с вебхуками — этот блок можно убрать
    pollSCM('* * * * *')
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Docker Image') {
      steps {
        dir('app/flask-app') {
          sh 'docker build -t $IMAGE_NAME:latest .'
        }
      }
    }

    stage('Unit Tests') {
      steps {
        dir('app/flask-app') {
          sh 'pip install -r requirements.txt'
          sh 'pytest --maxfail=1 --disable-warnings -q'
        }
      }
    }

    stage('SonarQube Analysis') {
      steps {
        withSonarQubeEnv("${SONARQUBE}") {
          sh 'sonar-scanner -Dsonar.projectKey=flask-app'
        }
      }
    }

    stage('Push to Docker Hub') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: env.CRED_DOCKER,
          usernameVariable: 'DOCKER_USER',
          passwordVariable: 'DOCKER_PASS'
        )]) {
          sh '''
            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
            docker push $IMAGE_NAME:latest
          '''
        }
      }
    }

    stage('Deploy with Helm') {
      steps {
        withCredentials([file(
          credentialsId: env.CRED_KUBE,
          variable: 'KUBECONFIG'
        )]) {
          sh """
            helm upgrade --install flask-app $CHART_PATH \
              --namespace $NAMESPACE --create-namespace \
              --values $CHART_PATH/values.yaml
          """
        }
      }
    }

    stage('Smoke Test') {
      steps {
        sh 'sleep 15'
        sh 'curl -f http://localhost:8080/ || exit 1'
      }
    }
  }

  post {
    success {
      mail to: '<YOUR_EMAIL>',
           subject: "SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
           body: "Pipeline succeeded"
    }
    failure {
      mail to: '<YOUR_EMAIL>',
           subject: "FAILURE: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
           body: "Pipeline failed"
    }
  }
}

