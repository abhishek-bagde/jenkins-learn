pipeline {
    agent any
    
    environment {
        ARM_CLIENT_ID     = credentials('ARM_CLIENT_ID')
        ARM_CLIENT_SECRET = credentials('ARM_CLIENT_SECRET')
    }

    stages{
        stage('Clean Workspace'){
            steps{
                cleanWs()
            }
        }
        
        stage('Checkout from Git'){
            steps{
                git branch: 'main', url: 'https://github.com/abhishek-bagde/jenkins-learn.git'
            }
        } 
        
        stage("Docker Build & Push"){
            steps{
                    sh 'docker build -t hellodocker:${BUILD_ID} .'
                    sh 'docker login creadevsouthindia001.azurecr.io -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET'
                    sh 'docker push myacr.azurecr.io/myimage:${BUILD_ID}'
                }
            }
    }
}
    // post {
    //     always {
    //         // Remove the Docker image from the Jenkins agent
    //         sh 'docker rmi myimage:${BUILD_ID}'
    //     }