node('master') 
{    
	cleanWs()
     stage('Code Checkout')
        {
   
        echo 'Checking out code...'
        def scmVars = checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'dnagit', url: 'https://github.com/spring-projects/spring-petclinic.gitgiturl']]])
            echo "scmVars.GIT_COMMIT"
            echo "${scmVars.GIT_COMMIT}"
            env.GIT_COMMIT = scmVars.GIT_COMMIT
            echo "env.GIT_COMMIT"
            echo "${env.GIT_COMMIT}"
    	      // def name = "${env.Docker_Repo_Url}/spring-petclinic"  ## "env.Docker_Repo_Url  is stored in Jenkins => Manage Jenkins => configure system => Environment variables"
    	      def version = "${env.BUILD_NUMBER}"
            echo "${name}"
            echo "${version}"
            env.IMAGENAME = "${name}"
            env.IMAGETAG = "${version}"
            env.DOCKERREPO = "${env.Docker_Repo_Url}"  ## "env.Docker_Repo_Url  is stored in Jenkins => Manage Jenkins => configure system => Environment variables"
            echo "${env.IMAGENAME}"
            echo "${env.IMAGETAG}"

        }

    stage('Unit Testing') 
        {
            echo 'Building ..'
 		     sh returnStdout: true, script: '''
            echo $PATH
            echo ${WORKSPACE}
            mvn versions:set -DnewVersion=${BUILD_NUMBER}
            mvn clean install ''' 
         }
    stage('Code Quality Analysis') 
        {
            echo 'Analysing code...'
            env.SONARURL = "${env.Sonar_Url}"
            withCredentials([usernamePassword(credentialsId: 'devopscoeuser', passwordVariable: 'sonarpassword', usernameVariable: 'sonaruser')])
            {
            sh '''
             mvn sonar:sonar -Dsonar.login=${sonaruser} -Dsonar.password=${sonarpassword} -Dsonar.host.url=\'https://sonar_url/\'
             '''
             }
        }
    stage('Build Docker Image') {
                echo 'Building ..'
 		        withCredentials([usernamePassword(credentialsId: 'devopscoeuser', passwordVariable: 'registrypassword', usernameVariable: 'registryuser')])
 		        {
 		        sh '''
 		           docker build -t $IMAGENAME:$IMAGETAG --build-arg version=${IMAGETAG} .
 		        '''
            }
        }
    stage('Push Docker Image to Docker Registry') {
                echo "Pushing to Registry .. ${env.DOCKERREPO}"
 		        withCredentials([usernamePassword(credentialsId: 'devopscoeuser', passwordVariable: 'registrypassword', usernameVariable: 'registryuser')])
 		        {
 		        sh '''
 		        docker login $DOCKERREPO -u ${registryuser} -p ${registrypassword}
 		        docker push $IMAGENAME:$IMAGETAG
                docker tag $IMAGENAME:$IMAGETAG $IMAGENAME:latest
                docker push $IMAGENAME:latest 
 		        docker rmi -f $IMAGENAME:$IMAGETAG
                docker rmi -f $IMAGENAME:latest
 		        '''
            }
        }
}
