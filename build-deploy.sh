#!/bin/bash

eval $(minikube docker-env)

OP=${1:-all}

# or ..
if [ $# -lt 1 ]; then
  echo -e "arguments: all | build | apply | delete \nconginue with argument = $OP.."
fi

if [[ "$OP" == "build" ]] || [[ "$OP" == "all" ]]; then
  docker build -t local-registry/django-polls:latest -f Dockerfile .
  OP=apply
fi 

if [[ "$OP" == "apply" || "$OP" == "delete" || "$OP" == "all" ]]; then
  for manifest in k8s/*.yaml; do
    kubectl $OP -f ${manifest}
  done
  kubectl rollout restart deploy polls-deployment
fi
