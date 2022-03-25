pipelineJob('S3 Buckets') {
    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        credentials("jenkins-token")
                        url("https://github.com/amoragon/cicd-practica-antonio.git")
                    }
                    branches("main")
                    scriptPath('Jenkinsfile.buckets')
                }
            }
        }
    }
}
