pipeline {
    // Définir l'agent global
    agent any

    // Définir les variables d'environnement
    environment {
        CONTAINER_ID = 'e67d4f2089ee55495c913635ecba060056f9c864aec8ddcdd2a8e721c70dce13' // ID du conteneur sera stocké ici
        SUM_PY_PATH = './sum.py' // Chemin vers le script sum.py sur la machine locale
        DIR_PATH = '.' // Chemin vers le répertoire contenant le Dockerfile
    }

    stages {
        // Étape 1 : Construction de l'image Docker
        stage('Build Docker Image') {

            steps {
                echo 'Building the Docker image...'
                echo "${DIR_PATH}"
                bat '''
                docker build -t python-sum .
                '''
            }
        }

        // Étape 2 : Exécution du conteneur Docker
        stage('Run Docker Container') {
            steps {
                echo 'Running the Docker container...'
                script {
                    // Lancer le conteneur en mode détaché
                    // CONTAINER_ID = bat(
                    //     script: "docker run -dit python-sum",
                    //     returnStdout: true
                    // ).trim()
                    env.CONTAINER_ID_RUN = bat(script: 'docker run -dit python-sum', returnStdout: true).trim()
                    echo "Container ID: ${env.CONTAINER_ID_RUN}"
                    echo "Container ID: ${CONTAINER_ID_RUN}"
                }
            }
        }

        // Étape 3 : Tests dans le conteneur
        stage('Run Tests') {
            steps {
                echo 'Running tests inside the container...'
                // Copier le fichier de test dans le conteneur
                bat '''
                    docker cp "%SUM_PY_PATH%" "%CONTAINER_ID_RUN%:/app/sum.py"
                '''
                // Tester des paires de nombres depuis le fichier de test
                bat '''
                    @echo off
                    setlocal enabledelayedexpansion

                    for /F "tokens=1,2,3 delims= " %%A in (test_variables.txt) do (
                        set NUM1=%%A
                        set NUM2=%%B
                        set EXPECTED=%%C

                        rem Exécuter sum.py dans le conteneur avec les nombres
                        for /F %%R in ('docker exec %CONTAINER_ID_RUN% python /app/sum.py !NUM1! !NUM2!') do (
                            set RESULT=%%R
                        )

                        rem Vérifier si le résultat correspond à la valeur attendue
                        if !RESULT! NEQ !EXPECTED! (
                            echo Test failed for inputs !NUM1!, !NUM2!: Expected !EXPECTED!, but got !RESULT!
                            exit /b 1
                        ) else (
                            echo Test passed for inputs !NUM1!, !NUM2!
                        )
                    )
                '''

            }
        }

        // Étape 4 : Nettoyage .
        stage('Cleanup ') {
            steps {
                echo 'Stopping and removing the container...'
                    bat '''
                docker stop %CONTAINER_ID_RUN%
                docker rm %CONTAINER_ID_RUN%
            '''

            }
        }

        //Etape5: Dockerhub
        stage('Deploy to DockerHub') {
            steps {
                script {
                    // Connexion à DockerHub
                    withCredentials([string(credentialsId: 'dockerhub-credentials', variable: 'DOCKER_PASSWORD')]) {
                        bat "echo \$DOCKER_PASSWORD | docker login -u ladydaina24 --@Dk693040533-stdin"
                    }
                    
                    // Tag de l'image
                    bat "docker tag ladydaina24/python-sum:latest"
                    
                    // Push de l'image
                    bat "docker push ladydaina24/python-sum:latest"
                    
                }
            }
        }    
    }
}
