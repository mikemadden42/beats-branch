pipeline {
    agent { docker { image 'johnnypetersringo/beats-branch:0.1.0' } }
    parameters {
        string defaultValue: '7.x', description: 'Current beats branch', name: 'CURRENT_BRANCH', trim: true
        string defaultValue: '7.8', description: 'New beats branch', name: 'NEW_BRANCH', trim: true
        string defaultValue: '7.7.0', description: 'Current beats snapshot', name: 'CURRENT_SNAPSHOT', trim: true
        string defaultValue: '7.8.0', description: 'New beats snapshot', name: 'NEW_SNAPSHOT', trim: true
        string defaultValue: '7.6.2', description: 'Latest beats release', name: 'LATEST_RELEASE', trim: true
        booleanParam defaultValue: false, description: 'Push new beats branch?', name: 'PUSH_BRANCH'
    }
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
                echo "CURRENT_BRANCH: ${params.CURRENT_BRANCH}"
                echo "NEW_BRANCH: ${params.NEW_BRANCH}"
                echo "CURRENT_SNAPSHOT: ${params.CURRENT_SNAPSHOT}"
                echo "NEW_SNAPSHOT: ${params.NEW_SNAPSHOT}"
                echo "LATEST_RELEASE: ${params.LATEST_RELEASE}"
                echo "PUSH_BRANCH: ${params.PUSH_BRANCH}"
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
                    git checkout ${params.CURRENT_BRANCH} 
                    git checkout -b ${params.NEW_BRANCH} 
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
                    sed -i "s/${params.LATEST_RELEASE}/${params.CURRENT_SNAPSHOT}/g" testing/environments/latest.yml
                    sed -i "s/${params.CURRENT_SNAPSHOT}/${params.NEW_SNAPSHOT}/g" testing/environments/snapshot-oss.yml
                    sed -i "s/${params.CURRENT_SNAPSHOT}/${params.NEW_SNAPSHOT}/g" testing/environments/snapshot.yml
                    sed -i "s/${params.CURRENT_BRANCH}/${params.NEW_BRANCH}/g" libbeat/docs/version.asciidoc
                    export GOPATH="/tmp/go"
                    export GOCACHE="/tmp/go-cache"
                    go env
                    ./dev-tools/set_docs_version ${params.NEW_SNAPSHOT} 
                    ./dev-tools/set_version ${params.NEW_SNAPSHOT} 
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