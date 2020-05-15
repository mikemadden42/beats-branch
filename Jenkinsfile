pipeline {
    agent { docker { image 'johnnypetersringo/beats-branch:0.1.0' } }
    stages {
        stage('info') {
            steps {
                sh """
                export PATH=/usr/local/go/bin:$PATH
                git --version
                go version
                mage --version
                make --version
                python3 --version
                sed --version
                """
            }
            post{
                success{
                    echo "========build executed successfully========"
                }
                failure{
                    echo "========build execution failed========"
                }
            }
        }
        stage('prep') {
            steps {
                sh """
                    mkdir -p /tmp/go-cache
                    mkdir -p /tmp/go/src/github.com/elastic
                    cd /tmp/go/src/github.com/elastic
                    git clone https://github.com/elastic/beats.git
                    cd beats
                    git checkout 7.x
                    git checkout -b 7.8
                """
            }
            post{
                success{
                    echo "========build executed successfully========"
                }
                failure{
                    echo "========build execution failed========"
                }
            }
        }
        stage('setup') {
            steps {
                sh """
                    export PATH=/usr/local/go/bin:$PATH
                    cd /tmp/go/src/github.com/elastic/beats
                    sed -i 's/7.6.2/7.7.0/g' testing/environments/latest.yml
                    sed -i 's/7.7.0/7.8.0/g' testing/environments/snapshot-oss.yml
                    sed -i 's/7.7.0/7.8.0/g' testing/environments/snapshot.yml
                    sed -i 's/7.x/7.8/g' libbeat/docs/version.asciidoc
                    export GOPATH="/tmp/go"
                    export GOCACHE="/tmp/go-cache"
                    go env
                    ./dev-tools/set_docs_version 7.8.0
                    ./dev-tools/set_version 7.8.0
                    make update
                """
            }
            post{
                success{
                    echo "========build executed successfully========"
                }
                failure{
                    echo "========build execution failed========"
                }
            }
        }
   }
    post{
        success{
            echo "========pipeline executed successfully ========"
        }
        failure{
            echo "========pipeline execution failed========"
        }
        always{
            junit "test-reports/junit.xml"
        }
    }
}