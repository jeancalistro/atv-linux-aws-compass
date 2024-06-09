output_path="./"
timezone="America/Sao_Paulo"

while getopts ":s:o:t:" options; do
  case ${options} in
    s)
      service=${OPTARG};;
    o)
      output_path=${OPTARG};;
    t)
      timezone=${OPTARG};;
    :)
      echo "Opção -${OPTARG} requer um argumento"
      exit 1;;
    ?)
      echo "Opção -${OPTARG} inválida"
      exit 1;;
  esac
done

isActive=$(systemctl is-active $service)
date=$(TZ=${timezone} date +'%d/%m/%Y %H:%M')

if [ "${isActive}" == "active" ]; then
  echo "${date} + ${service} + ${isActive} + Serviço está ONLINE" >> "${output_path}"/ONLINE.log

else
  echo "${date} + ${service} + ${isActive} + Serviço está OFFLINE" >> "${output_path}"/OFFLINE.log
fi