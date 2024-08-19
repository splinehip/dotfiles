#!/usr/bin/env bash

cfg="$HOME/Downloads/oak/kubeconfig.$1.json"
ns=$2
type=$3
service="jazz-$4"

if [[ $1 == "-h" || $1 == "-help" ]]; then
    echo "usage ./oak.sh cfg_name[dev05|cce] name_space[oak|dev06] type[pods|log|sh|del] service_name"
    echo -e "example for sip-manager log on dev05:\n./oak.sh dev05 oak log sip-manager"
    exit 0
fi

if [[ $type == "pods" ]]; then
    filter=""

    if [[ $service != "" ]]; then filter="| grep $service"; fi

    cmd="kubectl --kubeconfig $cfg -n $ns get pods $filter"

    echo "cmd: $cmd"
    echo "|| ========= Geted pods ========= ||"

    eval $cmd
    exit 0
fi

container_name=$(kubectl --kubeconfig $cfg -n $ns get pods | rg $service | awk '{print $1}')

echo "Try connecting using container name: $container_name"

if [[ $type == "log" ]]; then

    cmd="kubectl --kubeconfig $cfg -n $ns logs -f --tail=7000 $container_name \
    | zap-pretty | sed -u 's/\\n/\n/g' | sed -u 's/\\"/"/g'  | sed -u 's/\\r//g'"

    echo "cmd: $cmd"

    eval $cmd

elif [[ $type == "sh" ]]; then

    cmd="kubectl --kubeconfig $cfg exec -i -t -n $ns $container_name \
    -c $service -- sh -c \"clear; (bash || ash || sh)\""

    echo "cmd: $cmd"

    eval $cmd

elif [[ $type == "del" ]]; then

    cmd="kubectl --kubeconfig $cfg -n $ns delete pod $container_name --now"

    echo "cmd: $cmd"

    eval $cmd

fi
