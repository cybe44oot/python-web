pipeline {
    agent {
        docker { image 'docker:stable' }
    }
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
                script {
                    sh 'docker build -t ${DOCKER_IMAGE} .'
                }
            }
        }
        stage('Run Container') {
            steps {
                script {
                    // Stop and remove existing container if running
                    sh '''
                    docker ps -q --filter "name=${DOCKER_IMAGE}" | grep -q . && docker stop ${DOCKER_IMAGE} || true
                    docker rm ${DOCKER_IMAGE} || true
                    '''
                    // Run the container
                    sh 'docker run -d --name ${DOCKER_IMAGE} -p 9090:9090 ${DOCKER_IMAGE}'
                }
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
