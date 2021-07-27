String awxCredentials = "05fecac6-c0d8-4692-a0fb-ce4c3823f0b7"
String AWS_DEFAULT_REGION = "us-east-1"
String bran ="develop"

def getGitBranchName() {
    return scm.branches[0].name
}

node {
    properties([
    pipelineTriggers([pollSCM('* * * * *')])
  ])    
    stage('AWS Credentials'){
        withCredentials([[
            $class: 'AmazonWebServicesCredentialsBinding',
            credentialsId: 'AWS2',
            //credentialsId: 'IAM_USR_SVC_IAC_JNK',
            accessKeyVariable: 'AWS_ACCESS_KEY_ID',
            secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
        ]]) {
            env.AWS_ACCESS_KEY_ID = AWS_ACCESS_KEY_ID
            env.AWS_SECRET_ACCESS_KEY = AWS_SECRET_ACCESS_KEY            
        }
    }
    stage('AWX Credentials')
    withCredentials([usernamePassword(credentialsId: awxCredentials, usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
        env.AWX_USER = USERNAME
        env.AWX_PASS = PASSWORD   
    }
    

     stage('checkout'){
      echo 'Descargando codigo de SCM'
      sh 'rm -rf *'
      checkout scm
      echo "Cloning files from branch =  ${getGitBranchName()}"
    } 
   
    stage('Get services'){
        forlders = sh(script: "git log -1 --name-only --oneline | tail -n +2 | awk -F'/' '{print \$1}' | sort | uniq", returnStdout: true).trim().split('\n')
        echo_all(forlders, bran)
    }
} //END NODE

def echo_all(list, bn) {
    list.each { item ->
        
        t = sh(script: "if [ -d \"${item}\" ];then echo 1; else echo 0; fi", returnStdout: true).trim()
    
        if("${t}"=="1") {
            dir("${item}") {

                template_id = sh(script: "cat values."+bn+".tfvars | grep awx_template_id | awk -F' = ' '{print \$2}'", returnStdout: true).trim()
                echo "TEMPLATE_ID: , ${template_id}"
                
                    stage('Terraform Init'){
                            sh "terraform init"
                        }

                    stage('Terraform workspace select'){
                          try {
                               sh 'terraform workspace new ' + bn
                         } catch (err) {
                              sh 'terraform workspace select ' + bn
                             }
                            }
                
                    stage('Terraform Destroy') {
                        if (params.REQUESTED_ACTION == 'destroy') {
                            sh "terraform destroy -var-file=values."+bn+".tfvars -no-color --auto-approve"
                        }
                      }

                    stage('Terraform Plan'){
                        if (params.REQUESTED_ACTION != 'destroy') {
                        sh "terraform plan -var-file=values."+bn+".tfvars -no-color -out myplan"
                        }
                    }
                
                // SOLO PARA EL PIPELINE DE PRODUCCION //////////
                    stage('Terraform Approval') {
                        if (getGitBranchName() == 'master') {
                            script {
                                def userInput = input(id: 'confirm', message: 'Apply Terraform?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Apply terraform', name: 'confirm'] ])
                              }
                          }

                    }
                // SOLO PARA EL PIPELINE DE PRODUCCION //////////

                    stage('Terraform Apply'){
                        if (params.REQUESTED_ACTION != 'destroy') {
                        sh "terraform apply -no-color -input=false myplan"
                        }
                  }
            }
     }  else {
            echo "Dir not found"
        }
    }
}