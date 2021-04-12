#!/usr/bin/env bash
set -o errexit
set -o nounset

usage() {
  echo "Usage: ./pg-tool.sh -a [start|stop|status] -v [9.6|12|13]"
  exit 1
}

action=""
version=""

get_params() {
  while getopts "a:v:h:" arg; do
    case "${arg}" in
      a) action=${OPTARG};;
      v) version=${OPTARG};;
      h) usage
        exit 0
        ;;
    esac
  done
}

contains() {
  local array="$1[@]"
  local seeking=$2
  local in=1
  for element in "${!array}"; do
    if [[ $element == "$seeking" ]]; then
      in=0
      break
    fi
  done
  return $in
}

check_params() {
  # echo "a option: ${action}";
  # echo "v option: ${version}";
  arr_action=( "start" "stop" "status")
  arr_version=( "9.6" "12" "13" )

  contains arr_action "${action}" || usage
  contains arr_version "${version}" || usage
}

run(){
  /usr/local/opt/postgresql@${version}/bin/pg_ctl -D /usr/local/var/postgres/ -l /usr/local/var/log/postgres.log ${action}
}

main() {
  get_params "$@"
  check_params
  # echo "a option: ${action}";
  # echo "v option: ${version}";
  run
}

main "$@"
