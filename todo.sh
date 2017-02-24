#!/bin/bash

declare -a TODO_ITEMS
declare -a DONE_ITEMS

IFS=""
function readTodoFile {
    while read -r LINE; do
      TODO_ITEMS+=("$LINE")
    done < .todo.txt
}

function readDoneFile {
    while read -r LINE; do
      DONE_ITEMS+=("$LINE")
    done < .done.txt
}

function appendCurrentToToDoArray {
  local SIZE=${#TODO_ITEMS[@]}
  let "SIZE++"
  local ITEM=""
  for WORD in $@; do
    ITEM="${ITEM} ${WORD}"
  done
  TODO_ITEMS[${SIZE}]="${ITEM}"
}

function appendCurrentToDoneArray {
  DONE_ITEMS+=(TODO_ITEMS[$1])
}

function writeBackToFile {
  > .todo.txt
  for ITEM in ${TODO_ITEMS[@]}; do
    echo "${ITEM}" >> .todo.txt
  done
}

function writeBackToDoneFile {
  > .done.txt
  for ITEM in ${DONE_ITEMS[@]}; do
    echo "${ITEM}" >> .done.txt
  done
}

function add {
  readTodoFile
  appendCurrentToToDoArray $@
  writeBackToFile
  justListTodos
}

function printHelp {
  cat << EndOfMessage
    Usage:
      todo -a|--add <task>
      todo -d|--done <task's index to mark as completed>
EndOfMessage
}

function completeTask {
  readTodoFile
  readDoneFile

  appendCurrentToDoneArray $@

  local INDEX=$1
  INDEX=$((INDEX-1))
  unset TODO_ITEMS[$INDEX]
  writeBackToFile
  writeBackToDoneFile
  justListTodos
}

function justListTodos {
  local COUNT=1
  echo "TODO:"
  for ITEM in ${TODO_ITEMS[@]}; do
    echo "${COUNT}${ITEM}"
    let "COUNT++"
  done
}

function listTodos {
  readTodoFile
  justListTodos
}

while [[ $# -ge 1 ]]
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
        exit 0
      ;;
      -l|--list)
        shift
        listTodos
        exit 0
      ;;
      *)
        shift
        printHelp        # unknown option
        exit 0
      ;;
  esac
  shift # past argument or value
done
