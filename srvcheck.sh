#!/bin/bash

output_path="./"
timezone="America/Sao_Paulo"
active_message="Serviço está ativo"
inactive_message="Serviço está inativo"

while getopts ":s:o:t:a:i:" options; do
  case ${options} in
    s)
      service=${OPTARG};;
    o)
      output_path=${OPTARG};;
    t)
      timezone=${OPTARG};;
    a)
      active_message=${OPTARG};;
    i)
      inactive_message=${OPTARG};;
    :)
      echo "Opção -${OPTARG} requer um argumento"
      exit 1;;
    ?)
      echo "Opção -${OPTARG} inválida"
      exit 1;;
  esac
done

status=$(systemctl is-active $service)
date=$(TZ=${timezone} date +'%d/%m/%Y %H:%M')

if [ "${status}" == "active" ]; then
  echo "${date} + ${service} + ${status} + ${active_message}" >> "${output_path}"/ONLINE.log

else
  echo "${date} + ${service} + ${status} + ${inactive_message}" >> "${output_path}"/OFFLINE.log
fi