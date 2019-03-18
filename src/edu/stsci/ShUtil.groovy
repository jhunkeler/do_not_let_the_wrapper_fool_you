package edu.stsci

class ShUtil implements Serializable {
    def libroot = libraryResource('edu/stsci/init.sh')
    def environ = [:]

    def init() {
        def pairs = sh "source ${libroot}", returnStdout: true
    }

    def infect() {
        sh "echo"
    }
}
