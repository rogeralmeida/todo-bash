#!/bin/bash

declare -a TODO_ITEMS
IFS=""
function readTodoFile {
    local COUNT=1
    while read -r LINE; do
      if [ "$LINE" != "[TODO]" ]
      then
        TODO_ITEMS[${COUNT}]="$LINE"
        let "COUNT++"
      fi
    done < .todo.txt
}

function appendCurrentToArray {
  local SIZE=${#TODO_ITEMS[@]}
  let "SIZE++"
  local ITEM=""
  for WORD in $@; do
    ITEM="${ITEM} ${WORD}"
  done
  TODO_ITEMS[${SIZE}]="${ITEM}"
}

function writeBackToFile {
  > .todo.txt
  local COUNT=1
  echo "[TODO]" >> .todo.txt
  echo "TODO:"
  for ITEM in ${TODO_ITEMS[@]}; do
    echo "${ITEM}" >> .todo.txt
    echo "${COUNT}${ITEM}"
    let "COUNT++"
  done
}

function add {
  if [ -e .todo.txt ]
  then
    readTodoFile
  fi
  appendCurrentToArray $@
  writeBackToFile
}

function printHelp {
  cat << EndOfMessage
    Usage:
      todo -a|--add <task>
EndOfMessage
}

function completeTask {
  if [ -e .todo.txt ]
  then
    readTodoFile
  fi
  unset TODO_ITEMS[$1]
  writeBackToFile
}

while [[ $# -gt 1 ]]
do
  key="$1"

  case $key in
      -a|--add)
      shift # past argument
      add $@
      exit 0
      ;;
      -d|--done)
      shift # past argument
      completeTask $@
      ;;
      *)
        printHelp        # unknown option
      ;;
  esac
  shift # past argument or value
done


