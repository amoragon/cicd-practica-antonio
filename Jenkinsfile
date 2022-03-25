pipeline {
    agent {
        label 'terraform'
    }

    environment {
        AWS_ACCESS_KEY_ID = credentials('terraform-secrety-key')
        AWS_SECRET_ACCESS_KEY = credentials('terraform-secret-access-key')
    }

    options {
        timestamps()
    }

    stages {
        stage('Development') {
            steps {
                // Removes objects in DEV S3 bucket, if it exists
                sh '''
                    echo "Borrando objetos del bucket kc-acme-storage-dev..."
                    [[ $(aws s3 ls s3://kc-acme-storage-dev 2>&1 | grep "NoSuchBucket" | wc -l) -eq 0 ]] && \
                    aws s3 rm s3://kc-acme-storage-dev --recursive  || \
                    echo "No existe el bucket"
                '''

            }
        }

        stage('Production') {
            steps {
                // Removes objects in PROD S3 bucket, if it exists
                sh '''
                    echo "Borrando objetos del bucket kc-acme-storage-prd..." && \
                    [[ $(aws s3 ls s3://kc-acme-storage-prod 2>&1 | grep "NoSuchBucket" | wc -l) -eq 0 ]] && \
                    aws s3 rm s3://kc-acme-storage-prod --recursive  || \
                    echo "No existe el bucket" 
                '''
            }
        }
    }
}

