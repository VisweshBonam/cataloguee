pipeline {
    agent {
        label 'AGENT-1'
    }

    options {
        timeout(time:30, unit:'MINUTES') // set a timeout of 30 minutes for the entire pipeline
        disableConcurrentBuilds() // disable concurrent builds, only one build can run at a time
    }

    environment {
        appVersion = ''
        ACC_ID = '057260092371'
        REGION = 'us-east-1'
        PROJECT = 'roboshop'
        COMPONENT = 'cataloguee'
        IMAGE_VERSION = 'v1'
    }

    stages {
        
        stage('Read package.json') { // stage to read package.json file
            steps {
                script { // using script block to run a Groovy script
                    echo 'Reading package.json...'
                    def packageJson = readJSON file: 'package.json'
                    appVersion = packageJson.version
                    echo "Application Version: ${appVersion}"
                }
            }
        }


         stage('install dependencies') { // stage to install dependencies
            steps {
                script { // using script block to run a Groovy script
                   sh "npm install"
                    echo 'Dependencies installed successfully.'
                }
            }
        }

         stage('docker build') { // stage to build Docker image
            steps {
                script {
                     withAWS(credentials: 'aws-creds', region: '${REGION}') {
                           sh """
                           aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ACC_ID}.dkr.ecr.${REGION}.amazonaws.com 

                           docker build -t ${PROJECT}/${COMPONENT}:${IMAGE_VERSION} .

                          docker tag ${PROJECT}/${COMPONENT}:${IMAGE_VERSION} ${ACC_ID}.dkr.ecr.${REGION}.amazonaws.com/${PROJECT}/${COMPONENT}:${IMAGE_VERSION}

                          docker push ${ACC_ID}.dkr.ecr.${REGION}.amazonaws.com/${PROJECT}/${COMPONENT}:${IMAGE_VERSION}

                           """
                        }
                }
        }
    }

}