#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 <dir> \"<exec1> <exec2>...\""
  exit 1
fi

echo "Creating library subdirectories."
mkdir -p "$1" "$1/bin" "$1"/lib{,64}

IFS=' ' read -r -a exec_list <<< "$2"

for exec in "${exec_list[@]}"; do
  if [ -x /bin/"$exec" ]; then
     ldd /bin/"$exec" | awk '{print $3 ? $3 : $1}' | grep -v '^$' | while read -r lib; do
        if [[ "$lib" == */lib/* ]]; then
          target_d="$1/lib"
        elif [[ "$lib" == */lib64/* ]]; then
          target_d="$1/lib64"
        fi
        if [ -z "$target_d" ]; then
          echo "Can't determine directory for $lib for executable $exec, skipping."
        else
          cp -v "$lib" "$target_d/"
        fi
      cp /bin/"$exec" "$1/bin"
    done
  else
    echo "$exec couldn't be found in /bin/$exec, skipping."
  fi
done

echo "Created $1 dir with provided executables."