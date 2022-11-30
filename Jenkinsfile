node{

    def buildNumber=BUILD_NUMBER
    stage("SCM Checkout"){
        
        echo "---------------------------- Pulling Application's code from Github--------------------------------"
        
        git url:'https://github.com/abhishekkishor/java-web-app-docker.git', branch: 'master'
        
        echo "---------------------------- Pulled Application's code--------------------------------"
        
    }
    stage("Maven Clean Package"){
        
        echo "-------------------------------Maven Process--------------------------------"
        
        sh "mvn clean package"
        
        echo "-------------------------------Now Archiving the Artifacts....------------------------------------"
        
        archiveArtifacts artifacts: '**/*.war'
        
        echo "-------------------------------Artifacts Archieved....------------------------------------"
        
        echo "-------------------------------Check Project's Status------------------------------------"
    }
    
    stage("Build Docker Image"){
        
        echo "-------------------------------Building Application's Docker Image--------------------------------"
        
        sh "docker build -t abhishekkishor1/java_web_app_docker:${buildNumber} ."
        
        echo "-------------------------------Application's Docker Image Built--------------------------------"
    }
    
    stage("Dockerhub Login & Push"){
        
        echo "--------------------------Logging In Docker Hub----------------------------------"
        
        withCredentials([string(credentialsId: 'Docker_Hub_Pwd', variable: 'Docker_Hub_Pwd')]) {
        sh "docker login -u abhishekkishor1 -p ${Docker_Hub_Pwd}"
        
        echo "--------------------------Successfully Logged In Docker Hub----------------------------------"
    }
    
        echo "--------------------------Pushing Application Image In Docker Hub----------------------------------"
        
    sh "docker push abhishekkishor1/java_web_app_docker:${buildNumber}"
    
    echo "--------------------------Successfully Pushed Image In Docker Hub----------------------------------"
    }
    
    stage("Deploy Application As Docker Container"){
        
        def dockerRun='docker run -d -p 9090:8080 --name javawebcontainer abhishekkishor1/java_web_app_docker'
        
        sshagent(['Docker_Dev_Server_SSH']) {
            
            echo "--------------------------Logging In Deployment Server----------------------------------"
            
            sh "ssh -o StrictHostKeyChecking=no ubuntu@172.31.37.201"
            
            echo "--------------------------Successfully Logged In Deployment Server----------------------------------"
            
            // sh "ssh -o StrictHostKeyChecking=no ubuntu@172.31.37.201 docker container ls"
            
            echo "--------------------------List of Running containers----------------------------------"
            
            sh "ssh ubuntu@172.31.37.201 docker container ls"
            
            echo "--------------------------Stopping Running containers----------------------------------"
            
            sh "ssh ubuntu@172.31.37.201 docker stop javawebcontainer || true"
            
            echo "--------------------------Container stops----------------------------------"
            
            echo "--------------------------Removing Stopped Container ----------------------------------"
            
            sh "ssh ubuntu@172.31.37.201 docker rm javawebcontainer || true"
            
            echo "--------------------------Containers Removed----------------------------------"
            
            echo "--------------------------Listing Images----------------------------------"
            
            sh "ssh ubuntu@172.31.37.201 docker images || true"
            
            echo "--------------------------Removing All Images Forcefully----------------------------------"
            
            sh "ssh ubuntu@172.31.37.201 docker image prune -a -f || true"
            
            echo "--------------------------Images Deleted----------------------------------"
            
            echo "-------------------------Pulling Images from Docker Hub-------------------------------------"
            
            sh "ssh ubuntu@172.31.37.201 docker pull abhishekkishor1/java_web_app_docker:${buildNumber}"
            
            echo "-------------------------Running Pulled Image-----------------------------"
            
            sh "ssh ubuntu@172.31.37.201 ${dockerRun}:${buildNumber}"
            
            // sh "ssh ubuntu@172.31.37.201 docker run -d -p 9090:8080 --name javawebcontainer abhishekkishor1/java_web_app_docker:${buildNumber}"
            
        }
    }
}
