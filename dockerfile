pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "python-web"
        REPO_URL = "https://github.com/cybe44oot/python-web.git"
    }
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: "${REPO_URL}"
            }
        }
        stage('Build Docker Image') {
            steps {
                bat 'docker build -t ${DOCKER_IMAGE} .'
            }
        }
        stage('Run Container') {
            steps {
                bat '''
                REM Stop and remove existing container if running
                docker ps -q --filter "name=${DOCKER_IMAGE}" | findstr . && docker stop ${DOCKER_IMAGE} || echo No running container found.
                docker rm ${DOCKER_IMAGE} || echo No container to remove.
                '''
                bat 'docker run -d --name ${DOCKER_IMAGE} -p 9090:9090 ${DOCKER_IMAGE}'
            }
        }
    }
    post {
        success {
            echo "Application deployed successfully!"
        }
        failure {
            echo "Build or deployment failed!"
        }
    }
}
