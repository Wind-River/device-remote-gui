/* Define this in jenkins as :

   Create job :
   name : 4409-dashboard
   type : pipeline

   Pipeline :
   Pipeline script from SCM
   SCM : git
   URL : /opt/phallsma/device-remote-gui
   Branch : master
   Script path : pipelines/4409-dashboard.groovy 
*/

pipeline {
	agent {
		docker {
			image 'saxofon/wrlinux_builder:21'
			args '--name=4409-wrl-builder'
			args '-v /opt:/opt:Z'
			args '-v /var/jenkins_home:/var/jenkins_home:Z'
			args '--entrypoint=""'
		/*	reuseNode true */
		}
	}

	options {
		disableConcurrentBuilds()
		timestamps()
	}

	parameters {
		string(
			name: 'BRANCH',
			defaultValue: 'master',
			description: 'Define branch to build'
		)
		choice(
			name: 'BUILD_TYPE',
			choices: 'cache\nworkspace\nscratch',
			description: 'Build from previous workspace state, via caches for sstate/downloads or from scratch'
		)
		string(
			name: 'SSTATE_MIRROR_DIR',
			defaultValue: '/opt/phallsma/wrlinux-21/sstate-mirror',
			description: 'Directory for fetching/storing sstate cache'
		)
		booleanParam(
			name: 'SSTATE_UPDATE',
			defaultValue: true,
			description: 'Populate sstate cache from this builds sstate'
		)
	}

	environment {
		SSTATE_MIRROR_DIR="${params.SSTATE_MIRROR_DIR}"
		LANG="en_US.UTF-8"
	}

	stages {
		stage("Cleaning out workspace/build and starting from scratch") {
			when {
				expression {
					params.BUILD_TYPE == 'scratch' ||
					params.BUILD_TYPE == 'cache'
				}
			}
			steps {
				sh "make distclean"
			}
		}
/*
		stage("Git clone project layer") {
			steps {
				git branch: "${params.BRANCH}", url: '/opt/installs/repo_mirrors/misc/devices-remote-gui.git'
			}
		}
*/
		stage("Build images") {
			steps {
				sh "make images"
			}
		}
		stage("Update sstate cache") {
			when {
				expression {
					params.SSTATE_UPDATE == true
				}
			}
			steps {
				sh "make sstate-update"
			}
		}

	}
}
