
# Requirements and design

This project plans to offer a solution to run a workload into an easy to maintain and cost free implementation of K8s.
Key points:
  - run K8s on a local PC(e.g. w/ Minikube, Kind, Rancher.. etc)
  - find a secure way to expose services for public access (found CloudFlare Tunnel / Zero Trust)
  - easy and quick deploy and cleanup
  - open source / zero costs


1. Deploy sample application to the Kubernetes cluster

Check docs/*png for design and implementation details

CI/CD implementation is minimal, consisting in GitHub actions build triggered by git push and K8s Always pull policy for docker images.

Data security is covered by a combination of Externals Secrets + Vault(HashiCorp) operators. An initial manual setup is required for Vault to provision the initial secrets at the moment.


2. Design a backup process/solution

The implementation is minimal for simplicity, by a cronjob that periodically performs a Postgres DB backup.
Some implementation details are:
  - PersistenVolumes/Claims are used for data persistency
  - Postgres uses the same version for main DB and backup tools
  - backup tools is pg_dump for simplicity
  - a cleanup mechanism is also put in place
  - the backup script is available as a configmap



# Implementation details

## posgress / minikube
https://gist.github.com/ivanbrennan/cf20e26de6e7cbf517d101e7cc9d4ca0


## github actions / minikube
https://minikube.sigs.k8s.io/docs/tutorials/setup_minikube_in_github_actions/


# 1. Ubuntu Minikube (https://minikube.sigs.k8s.io/docs/start/?arch=%2Flinux%2Fx86-64%2Fstable%2Fbinary+download)

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64

  sudo usermod -aG docker $USER
  newgrp docker

minikube start
minikube dashboard
minikube stop   ( pause / unpause )

## Minikube expose DDNS noip
https://my.noip.com/dynamic-dns

## Minikube expose w/ Cloudflare Zero Trust (DDNS alternative)

https://developers.cloudflare.com/load-balancing/local-traffic-management/ltm-tunnels-setup/#set-up-private-ips-with-cloudflare-tunnel
https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/

  cccccc domain
  api.domain_name.com

minikube service polls-service --url
http://192.168.49.2:30090

# 2. Docker images
./build-deploy.sh 







# Task that consists of two parts:
- show us your practical skills by building a simple cluster
- show us your way of thinking by preparing a proposal for a new backup process

1. Deploy sample application to the Kubernetes cluster
Build and deploy an application from this repository:
https://github.com/agilentia/devops-challenge
Use whatever service or platform you want (AWS, Azure, GCP, bare metal, and so on). Most of them have a free tier option.
Feel free to use whatever tools you want, in the end, we want to see this application started somewhere.
Requirements:
1. Application must run as a Docker container.
2. Create some basic CI/CD pipeline to build and deploy using GitHub Actions
3. Push your code to the Github repository

Minimum requirements
- deployed application publicly available
- deployment to some kind of Kubernetes cluster
- Infrastructure as a Code

Nice to have
- Encryption of sensitive data
How is the task graded?
We are looking for well-defined code, security, and availability of the solution. We want to
see how you think and tackle the problems.

2. Design a backup process/solution
In this task, we would like to ask you to write down a proposal for the backup
process/solution for an application you have created in Step 1.

Minimum requirements
- The proposed solution is written down with an explanation of why you decided to
choose it and what considerations you took during the thinking process
- List the tools you propose to use with a short description of why this / these but not
the others

Nice to have
- actual backup script shared with us

What we value
- Details of the configuration
- Usage of Open Source tools

How is the task graded?
We are looking for a structured document where you will show us your way of approaching
challenges and proposing solutions.

What should I do when I'm finished?
1. Please send us your GitHub username, so we can give you access to a git
repository to push your code to
2. Provide a backup solution/proposal in any form you wish - it can be Google Docs,
Word, or even a simple text file.

