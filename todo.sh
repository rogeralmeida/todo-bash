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

add $@

exit 0
