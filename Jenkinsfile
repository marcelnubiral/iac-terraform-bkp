String awxCredentials = "05fecac6-c0d8-4692-a0fb-ce4c3823f0b7"
String AWS_DEFAULT_REGION = "us-east-1"
String bran = "develop"
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
            credentialsId: 'IAM_USR_SVC_IAC_JNK',
            accessKeyVariable: 'AWS_ACCESS_KEY_ID',
            secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
        ]]) {
            env.AWS_ACCESS_KEY_ID = AWS_ACCESS_KEY_ID
            env.AWS_SECRET_ACCESS_KEY = AWS_SECRET_ACCESS_KEY            
        }
    }

    stage('get parameter store values'){
        awx_user = sh(
            returnStdout: true, 
            script:"aws --region=us-east-1 ssm get-parameter --name '/nubiral/sandbox/packer-build/jenkins-user' --with-decryption --output text --query Parameter.Value"
        ).trim()

        awx_pwd = sh(
            returnStdout: true, 
            script:"aws --region=us-east-1 ssm get-parameter --name '/nubiral/sandbox/packer-build/jenkins-pwd' --with-decryption --output text --query Parameter.Value"
        ).trim()
        
        ansible_win_user = sh(
            returnStdout: true, 
            script:"aws --region=us-east-1 ssm get-parameter --name '/nubiral/sandbox/packer-build/ansible-win-user' --with-decryption --output text --query Parameter.Value"
        ).trim()

        ansible_win_pwd = sh(
            returnStdout: true, 
            script:"aws --region=us-east-1 ssm get-parameter --name '/nubiral/sandbox/packer-build/ansible-win-pwd' --with-decryption --output text --query Parameter.Value"
        ).trim()
    } 

    stage('checkout'){
        echo 'Descargando codigo de SCM'
        sh 'rm -rf *'
        checkout scm
        echo "Cloning files from branch =  ${getGitBranchName()}"
    } 
    stage ('Plugins Provider AWX'){
        sh 'rm -rf ~/.terraform.d/'
        sh 'chmod 777 terraform-provider-awx'
        sh 'mkdir -p ~/.terraform.d/plugins/terraform.arcos/local/awx/0.2.3/linux_amd64'
        sh 'cp -r terraform-provider-awx  ~/.terraform.d/plugins/terraform.arcos/local/awx/0.2.3/linux_amd64/'     
    }    
   
    stage('Get services'){
        forlders = sh(script: "git log -1 --name-only --oneline | tail -n +2 | awk -F'/' '{print \$1}' | sort | uniq", returnStdout: true).trim().split('\n')
        echo_all(forlders, bran)
    }

    

    
} //END NODE
def echo_all(list, bn) {
    list.each { item ->
        
        t = sh(script: "if [ -d \"${item}\" ];then echo 1; else echo 0; fi", returnStdout: true).trim()
    
        if ("${t}" == "1") {
            dir("${item}") {
                template_id = sh(script: "cat values."+bn+".tfvars | grep awx_template_id | awk -F' = ' '{print \$2}'", returnStdout: true).trim()
                echo "TEMPLATE_ID: , ${template_id}"
                
                    stage('Terraform Init'){
                        sh 'rm -rf .terraform'
                        sh 'terraform init -upgrade'
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
                            sh(
                                returnStdout: true,
                                script: "set +e \
                                        terraform destroy \ 
                                        -var 'awx_user=${awx_user}' \
                                        -var 'awx_pwd=${awx_pwd}' \
                                        -var 'ansible_win_user=${ansible_win_user}' \
                                        -var 'ansible_win_pwd=${ansible_win_pwd}' \
                                        -var-file=values.${bn}.tfvars \
                                        -no-color \
                                        --auto-approve"
                            ).trim()
                        }
                    }
                    stage('Terraform Plan'){
                        if (params.REQUESTED_ACTION != 'destroy') {
                            sh(
                                returnStdout: true,
                                script: "set +e \
                                terraform plan \
                                -var 'awx_user=${awx_user}' \
                                -var 'awx_pwd=${awx_pwd}' \
                                -var 'ansible_win_user=${ansible_win_user}' \
                                -var 'ansible_win_pwd=${ansible_win_pwd}' \
                                -var-file=values.${bn}.tfvars \
                                -no-color \
                                -out myplan"
                            ).trim()            
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
                    
                    //time
                    // stage ("wait_prior_starting_smoke_testing") {
                    // echo 'Waiting 1 minute for deployment to complete prior starting smoke testing'
                    // sleep 60 // seconds
                    // } 
                    // stage('Hardening') {
                    //     timeout(time: 2, unit: 'HOURS') {
                    //         build job: 'IAC-HARDENING-AWS', parameters: [
                    //         string(name: 'SERVICE', value: "${item}"),
                    //         string(name: 'TEMPLATE_ID', value: "${template_id}"),
                    //         string(name: 'BRANCH', value: "${getGitBranchName()}")
                    //         ]
                    //     }
                    // } 
                }
     }  else {
            echo "Dir not found"
        }
    }
}