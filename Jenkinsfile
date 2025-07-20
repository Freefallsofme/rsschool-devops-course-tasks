pipeline {
    agent {
        kubernetes {
            label 'sonar-flask-agent'
            yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: docker
    image: docker:25.0.3-dind
    securityContext:
      privileged: true
    tty: true
    volumeMounts:
    - name: workspace-volume
      mountPath: /home/jenkins/agent
  - name: helm
    image: alpine/helm:3.14.3
    tty: true
    volumeMounts:
    - name: workspace-volume
      mountPath: /home/jenkins/agent
  - name: jnlp
    image: jenkins/inbound-agent:alpine
    env:
      - name: JENKINS_URL
        value: "http://jenkins.devops-tools.svc.cluster.local:8080/"
    volumeMounts:
    - name: workspace-volume
      mountPath: /home/jenkins/agent
  volumes:
  - name: workspace-volume
    emptyDir: {}
"""
        }
    }

    environment {
        DOCKERHUB_CRED = credentials('docker-hub-creds')
        SONARQUBE_SERVER = 'SonarQube' // Имя SonarQube сервера в Jenkins (см. в настройках)
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('SonarQube Analysis') {
            steps {
                container('docker') {
                    script {
                        withSonarQubeEnv(SONARQUBE_SERVER) {
                            sh 'sonar-scanner -Dsonar.projectKey=flask-app -Dsonar.sources=app'
                        }
                    }
                }
            }
        }

        stage('Build Docker image') {
            steps {
                container('docker') {
                    dir('app/flask-app') {
                        sh '''
                            dockerd-entrypoint.sh &
                            sleep 10
                            docker build -t atatara/rsschool-flask .
                        '''
                    }
                }
            }
        }

        stage('Push Docker image') {
            steps {
                container('docker') {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', passwordVariable: 'DOCKERHUB_PASS', usernameVariable: 'DOCKERHUB_USER')]) {
                        sh '''
                            echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USER --password-stdin
                            docker push atatara/rsschool-flask
                        '''
                    }
                }
            }
        }

        stage('Deploy with Helm') {
            steps {
                container('helm') {
                    dir('helm/flask-app') {
                        sh 'helm upgrade --install flask-app . --set image.repository=atatara/rsschool-flask'
                    }
                }
            }
        }
    }
}

