#!/bin/bash
TMPFILE="/tmp/.bashweb.$(whoami)"
PORT=8000

start(){
   [[ -n "$1" ]] && PORT="$1"; TMPFILE="$TMPFILE.$PORT"; [[ ! -p $TMPFILE ]] && mkfifo "$TMPFILE"
   which xdg-open &>/dev/null && xdg-open "http://localhost:$PORT" || echo "[x] surf to http://localhost:$PORT"
   while [[ -p "$TMPFILE" ]]; do
     [[ -f "$TMPFILE.log" ]] && tail -n5 $TMPFILE.log
     { read line<$TMPFILE;
       logmsg(){ cat - | while read l; do echo "[$(date)] $1> $l" >> $TMPFILE.log; [[ ! "$1" == "in" ]] && echo "$l"; done; }
       message="$( echo "$line" | sed 's/[\n\r]//g')"
       method="$(echo "$message" | sed 's/ \/.*//g' )"
       url="$(echo "$message" | sed 's/GET //g;s/POST //g;s/DELETE //g;s/PUT //g;s/ HTTP.*//g')"
       echo "$method $url" | logmsg in
       echo -e "HTTP/1.1 200 OK\r\n"  | logmsg out
       $0 onUrl "$method" "$url" "$TMPFILE"
     } | nc -v -l $PORT > $TMPFILE | tee -a $TMPFILE.log
   done
}

onUrl(){
  method="$1"; url="$2"; tmpfile="$3"; file="html$url"
  
  case $url in
    /REST)    echo '{"code":0, "message": "'$(date)'" }'
              ;;

    /)        cat html/index.html
              ;;

    /log)     echo "<html><body><pre>$(tail -n15 "$3.log")</pre></body></html>"
              ;;

    *)        [[ -f "$file" ]] && cat "$file" || onUrl "$1" "/" "$3" # redirect     
              ;;
  esac
}

cleanup(){
  [[ -f "$TMPFILE" ]] && rm "$TMPFILE"
  echo "server stopped"
  exit
}

trap cleanup SIGINT
if [[ -n "$1" ]]; then "$@"; else start; fi
