#!/usr/bin/env bash
ns=$1
service=$2
type=$3

if [[ $3 == "log" ]]; then

    kubectl --kubeconfig ~/Downloads/kubeconfig -n $ns logs -f --tail=7000 \
    $(kubectl --kubeconfig ~/Downloads/kubeconfig -n $ns get pods | rg $service | awk '{print $1}') \
    | zap-pretty | sed -u 's/\\n/\n/g' | sed -u 's/\\"/"/g'  | sed -u 's/\\r//g'

elif [[ $3 == "sh" ]]; then

    kubectl --kubeconfig ~/Downloads/kubeconfig exec -i -t -n $ns \
    $(kubectl --kubeconfig ~/Downloads/kubeconfig -n $ns get pods | rg $service | awk '{print $1}') \
    -c $service -- sh -c "clear; (bash || ash || sh)"

fi
