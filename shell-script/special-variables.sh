#!bin/bash

 ##### Special Variables  ####

 echo "All args paased to script: $@"
 echo "Number of vars passed to script $#"
 echo "Secript name: $0"
 echo "Present directory: $PWD"
 echo "who is running: $USER"
 echo "Home directory of current user: $HOME"
 echo "PID Of this script: $$"
 sleep 200&
 echo "PID of the recently excuted background process: $!"
 echo "ALL args passed to script: $*"