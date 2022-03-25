// String awxCredentials = "05fecac6-c0d8-4692-a0fb-ce4c3823f0b7"
// String AWS_DEFAULT_REGION = "us-east-1"
// String bran = "testing"
// def getGitBranchName() {
//     return scm.branches[0].name
// }
// def branch = getGitBranchName()
// node {
//     properties([
//     pipelineTriggers([pollSCM('* * * * *')])
//   ])    
    // stage('AWS Credentials'){
    //     withCredentials([[
    //         $class: 'AmazonWebServicesCredentialsBinding',
    //         credentialsId: 'IAM_USR_SVC_IAC_JNK',
    //         accessKeyVariable: 'AWS_ACCESS_KEY_ID',
    //         secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
    //     ]]) {
    //         env.AWS_ACCESS_KEY_ID = AWS_ACCESS_KEY_ID
    //         env.AWS_SECRET_ACCESS_KEY = AWS_SECRET_ACCESS_KEY            
    //     }
    // }

//     stage('get parameter store values'){
//         awx_user = sh(
//             returnStdout: true, 
//             script:"aws --region=us-east-1 ssm get-parameter --name '/nubiral/sandbox/packer-build/jenkins-user' --with-decryption --output text --query Parameter.Value"
//         ).trim()

//         awx_pwd = sh(
//             returnStdout: true, 
//             script:"aws --region=us-east-1 ssm get-parameter --name '/nubiral/sandbox/packer-build/jenkins-pwd' --with-decryption --output text --query Parameter.Value"
//         ).trim()
        
//         ansible_win_user = sh(
//             returnStdout: true, 
//             script:"aws --region=us-east-1 ssm get-parameter --name '/nubiral/sandbox/packer-build/ansible-win-user' --with-decryption --output text --query Parameter.Value"
//         ).trim()

//         ansible_win_pwd = sh(
//             returnStdout: true, 
//             script:"aws --region=us-east-1 ssm get-parameter --name '/nubiral/sandbox/packer-build/ansible-win-pwd' --with-decryption --output text --query Parameter.Value"
//         ).trim()

//         domain_user = sh(
//             returnStdout: true, 
//             script:"aws --region=us-east-1 ssm get-parameter --name '/nubiral/sandbox/packer-build/domain_user' --with-decryption --output text --query Parameter.Value"
//         ).trim()

//         domain_pwd = sh(
//             returnStdout: true, 
//             script:"aws --region=us-east-1 ssm get-parameter --name '/nubiral/sandbox/packer-build/domain_pwd' --with-decryption --output text --query Parameter.Value"
//         ).trim()
//     } 


//     stage('checkout'){
//         echo 'Descargando codigo de SCM'
//         sh 'rm -rf *'
//         checkout scm
//         echo "Cloning files from branch =  ${getGitBranchName()}"
//         sh 'curl -k https://172.21.1.149:8043'
//     } 
//     stage ('Plugins Provider AWX'){
//         sh 'rm -rf ~/.terraform.d/'
//         sh 'chmod 777 terraform-provider-awx'
//         sh 'mkdir -p ~/.terraform.d/plugins/terraform.arcos/local/awx/0.2.3/linux_amd64'
//         sh 'cp -r terraform-provider-awx  ~/.terraform.d/plugins/terraform.arcos/local/awx/0.2.3/linux_amd64/'     
//     }    
   
//     stage('Get services'){
//         forlders = sh(script: "git log -1 --name-only --oneline | tail -n +2 | awk -F'/' '{print \$1}' | sort | uniq", returnStdout: true).trim().split('\n')
//         // ambientes = sh(script: "${getGitBranchName()}"
//         echo 'ambiente: '+ branch
//         echo_all(forlders,branch)
//     }

    

    
// } //END NODE
// def echo_all(list, bn) {
//     list.each { item ->
        
//         t = sh(script: "if [ -d \"${item}\" ];then echo 1; else echo 0; fi", returnStdout: true).trim()
    
//         if ("${t}" == "1") {
//             dir("${item}") {
//                 template_id = sh(script: "cat values."+bn+".tfvars | grep awx_template_id | awk -F' = ' '{print \$2}'", returnStdout: true).trim()
//                 echo "TEMPLATE_ID: , ${template_id}"
                
//                     stage('Terraform Init'){
//                         sh 'rm -rf .terraform'
//                         sh 'terraform init'
//                         sh 'terraform workspace new ' + bn
//                         sh 'terraform workspace select ' + bn
//                         sh "terraform plan -var 'domain_user=${domain_user}' -var 'domain_pwd=${domain_pwd}' -var 'awx_user=${awx_user}' -var 'awx_pwd=${awx_pwd}' -var 'ansible_win_user=${ansible_win_user}' -var 'ansible_win_pwd=${ansible_win_pwd}' -var-file=values.testing.tfvars -no-color -out myplan"
//                     }
//                     // stage('Terraform workspace select'){
//                     //       try {
//                     //            sh 'terraform workspace new ' + bn
//                     //      } catch (err) {
//                     //           sh 'terraform workspace select ' + bn
//                     //       }
//                     // }

//                     // stage ('crear userdata.sh'){
//                     //     sh "set +x; echo '\n echo ${domain_pwd} | realm join -U ${domain_user} aws.local'  >> /var/lib/jenkins/workspace/IAC-INFRA-AWS/${item}/user_data/userdata.sh"
//                     // }
                
//                     // stage('Terraform Destroy') {
//                     //     if (params.REQUESTED_ACTION == 'destroy') {
//                     //         sh "set +x; terraform destroy -var 'domain_user=${domain_user}' -var 'domain_pwd=${domain_pwd}' -var 'awx_user=${awx_user}' -var 'awx_pwd=${awx_pwd}' -var 'ansible_win_user=${ansible_win_user}' -var 'ansible_win_pwd=${ansible_win_pwd}' -var-file=values.${bn}.tfvars -no-color --auto-approve"
//                     //     }
//                     // }
//                     // stage('Terraform Plan'){
//                     //     if (params.REQUESTED_ACTION != 'destroy') {
//                     //         sh "set +x; terraform plan -var 'domain_user=${domain_user}' -var 'domain_pwd=${domain_pwd}' -var 'awx_user=${awx_user}' -var 'awx_pwd=${awx_pwd}' -var 'ansible_win_user=${ansible_win_user}' -var 'ansible_win_pwd=${ansible_win_pwd}' -var-file=values.${bn}.tfvars -no-color -out myplan"  
//                     //     }
//                     // }
                
//                     // SOLO PARA EL PIPELINE DE PRODUCCION //////////
//                     stage('Terraform Approval') {
//                         if (getGitBranchName() == 'master') {
//                             script {
//                                 def userInput = input(id: 'confirm', message: 'Apply Terraform?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Apply terraform', name: 'confirm'] ])
//                             }
//                         }
//                     }
//                 // SOLO PARA EL PIPELINE DE PRODUCCION //////////
//                     stage('Terraform Apply'){
//                         if (params.REQUESTED_ACTION != 'destroy') {
//                         sh "terraform apply -no-color -input=false myplan"
//                         }
//                     }
                    
//                     //time
//                     // stage ("wait_prior_starting_smoke_testing") {
//                     // echo 'Waiting 1 minute for deployment to complete prior starting smoke testing'
//                     // sleep 60 // seconds
//                     // } 
//                     // stage('Hardening') {
//                     //     timeout(time: 2, unit: 'HOURS') {
//                     //         build job: 'IAC-HARDENING-AWS', parameters: [
//                     //         string(name: 'SERVICE', value: "${item}"),
//                     //         string(name: 'TEMPLATE_ID', value: "${template_id}"),
//                     //         string(name: 'BRANCH', value: "${getGitBranchName()}")
//                     //         ]
//                     //     }
//                     // } 
//                 }
//      }  else {
//             echo "Dir not found"
//         }
//     }
// }

pipeline {

    parameters {
        string(name: 'environment', defaultValue: 'terraform', description: 'Workspace/environment file to use for deployment')
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')

    }


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
    }

//    agent  any
//         options {
//                 timestamps ()
//                 ansiColor('xterm')
//             }
    stages {
        stage('checkout') {
            steps {
                 script{
                        dir("terraform")
                        {
                            git "https://github.com:goldenarch/iac-terraform.git"
                        }
                    }
                }
            }

        stage('Plan') {
            steps {
                sh 'pwd;cd terraform/aws-instance-first-script ; terraform init -input=false'
                sh 'pwd;cd terraform/aws-instance-first-script ; terraform workspace new ${environment}'
                sh 'pwd;cd terraform/aws-instance-first-script ; terraform workspace select ${environment}'
                sh "pwd;cd terraform/aws-instance-first-script ;terraform plan -input=false -out tfplan "
                sh 'pwd;cd terraform/aws-instance-first-script ;terraform show -no-color tfplan > tfplan.txt'
            }
        }
        stage('Approval') {
           when {
               not {
                   equals expected: true, actual: params.autoApprove
               }
           }

           steps {
               script {
                    def plan = readFile 'terraform/aws-instance-first-script/tfplan.txt'
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
               }
           }
       }

        stage('Apply') {
            steps {
                sh "pwd;cd terraform/aws-instance-first-script ; terraform apply -input=false tfplan"
            }
        }
    }

  }