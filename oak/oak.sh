#!/usr/bin/env bash

cfg="kubeconfig.$1"
ns=$2
type=$3
service=$4

if [[ $type == "pods" ]]; then
    echo "|| ========= Geted pods ========= ||"
    kubectl --kubeconfig ~/Downloads/oak/$cfg -n $ns get pods
    exit 0
fi

container_name=$(kubectl --kubeconfig ~/Downloads/oak/$cfg -n $ns get pods | rg $service | awk '{print $1}')

echo "Try connecting using container name: $container_name"

if [[ $type == "log" ]]; then

    kubectl --kubeconfig ~/Downloads/oak/$cfg -n $ns logs -f --tail=7000 $container_name \
    | zap-pretty | sed -u 's/\\n/\n/g' | sed -u 's/\\"/"/g'  | sed -u 's/\\r//g'

elif [[ $type == "sh" ]]; then

    kubectl --kubeconfig ~/Downloads/oak/$cfg exec -i -t -n $ns $container_name \
    -c $service -- sh -c "clear; (bash || ash || sh)"

fi
