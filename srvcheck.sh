output_path="./"
date=$(date +'%d/%m/%Y %H:%M')

while getopts ":s:" options; do
  case ${options} in
    s)
      service=${OPTARG};;
    :)
      echo "Opção -${OPTARG} requer um argumento"
      exit 1;;
    ?)
      echo "Opção -${OPTARG} inválida"
      exit 1;;
  esac
done

isActive=$(systemctl is-active $service)

if [ "${isActive}" == "active" ]; then
  echo "$date + $service + $isActive + Serviço está ONLINE" >> "$output_path"/ONLINE.log

else
  echo "$date + $service + $isActive + Serviço está OFFLINE" >> "$output_path"/OFFLINE.log
fi