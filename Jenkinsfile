pipeline {
    agent any
    
    // triggers {
    //     // Trigger the pipeline on every push to the main branch
    //     scm '*/main'
    // }

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
                sh 'docker build -t creadevsouthindia001.azurecr.io/helloworld:${BUILD_ID} .'
                sh 'docker login creadevsouthindia001.azurecr.io -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET'
                sh 'docker push creadevsouthindia001.azurecr.io/helloworld:${BUILD_ID}'
            }
        }

        stage("Deploy to AKS"){
            withKubeConfig([credentialsId: '', serverUrl: 'dns-aks-ea-dev-southindia-001-x20ppipv.hcp.southindia.azmk8s.io']) 
            steps{
                sh 'kubectl apply -f deployment.yaml'
                sh 'kubectl apply -f load-balancer-service.yaml'
            }
        }
    }
}