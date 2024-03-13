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

        stage('Deploy to kubernets'){
            steps{
                script{
                    dir('Kubernetes') {
                        withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: '', namespace: '', restrictKubeConfigAccess: false, serverUrl: '') {
                                sh 'kubectl apply -f deployment.yaml'
                                sh 'kubectl apply -f service.yaml'
                           }
                        }   
                }
            }
        }
    }
}