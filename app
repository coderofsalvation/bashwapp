#!/bin/bash
APPNAME="Your app"
TMPFILE="/tmp/.bashwapp.$(whoami)"
PORT=8000
pid=$$
CLIENT=$TMPFILE.fifo 

start(){
  [[ -n "$1" ]] && PORT="$1"; TMPFILE="$TMPFILE.$PORT"; 
#   which xdg-open &>/dev/null && xdg-open "http://localhost:$PORT" || echo "[x] surf to http://localhost:$PORT"
  [[ ! -p $CLIENT ]] && mkfifo $CLIENT 

  while [[ -p $CLIENT ]]; do 
    cat $CLIENT | nc -v -q -1 -l $PORT 2>&1 | onRequest 
  done
  line="$(cat -)"; console "<-" "$line" 
#
#   while [[ -p "$TMPFILE" ]]; do
#     [[ -f "$TMPFILE.log" ]] && tail -n5 $TMPFILE.log
#     { read line<$TMPFILE;
#       logmsg(){ cat - | while read l; do echo "[$(date)] $1> $l" >> $TMPFILE.log; [[ ! "$1" == "in" ]] && echo "$l"; done; }
#       message="$( echo "$line" | sed 's/[\n\r]//g')"
#       method="$(echo "$message" | sed 's/ \/.*//g' )"
#       url="$(echo "$message" | sed 's/GET //g;s/POST //g;s/DELETE //g;s/PUT //g;s/ HTTP.*//g')"
#       echo "$method $url" | logmsg in
#       echo -e "HTTP/1.1 200 OK\r\n"  | logmsg out
#       reply="$( $0 onUrl "$method" "$url" "$TMPFILE" )"; [[ "$reply" == "quit" ]] && kill -9 $pid || echo "$reply"
#     } | nc -v -l $PORT > $TMPFILE | tee -a $TMPFILE.log
#   done
  rm $CLIENT
}

console(){
  echo "[$(date)] bashwapp $1 $2" | tee $TMPFILE.log; return 0
}

onRequest(){
  cat - | while read line; do 
    console "<-" "$line" 
    [[ "$line" =~ "Connection from " ]] && CLIENT_IP="$(echo "$line" | sed s'/Connection from \[//g;s/\].*//g' )"
    [[ "$line" =~ "GET "             ]] || [[ "$line" =~ "GET"  ]] && parseUrl "$line" "GET"
    [[ "$line" =~ "POST "            ]] || [[ "$line" =~ "POST" ]] && parseUrl "$line" "POST"
    [[ "$line" =~ "Host: "           ]] && CLIENT_HOST="$(echo "$line" | sed 's/Host: //g')"
    [[ "$line" =~ "User-Agent: "     ]] && CLIENT_USERAGENT="$(echo "$line" | sed 's/User-Agent: //g')"
    [[ "$line" =~ "Accept: "         ]] && CLIENT_ACCEPT="$(echo "$line" | sed 's/Accept: //g')"
    if (( ${#line} == 1 )); then 
    #  (onUrl "$CLIENT" "$CLIENT_URL" &);
      echo "done"
      httpheader 200 > $CLIENT 
      echo "flop" > $CLIENT
      echo -e "\r\n\r\n" > $CLIENT
    fi
  done
}

parseUrl(){
  line="$1"; method="$2"
  CLIENT_URL="$(echo "$line" | sed "s/$method //g;s/ .*//g;s/?.*//g")"
  CLIENT_ARGS="$(echo "$line" | sed "s/.*?//g;s/ .*//g")"
}

onUrl(){
  CLIENT="$1"; url="$2"
  case "$url" in 

    /)        serveFile "html/index.html" "$CLIENT"; 
              ;;

    /rest)    echo '{"code":0, "message": "'$(date)'" }' > $CLIENT
              ;;

    /log)     echo "<html><body><pre>$(tail -n15 "$3.log")</pre></body></html>" > $CLIENT
              ;;

    /quit)    echo "quit";
              ;;

    *)        [[ -f "$file" ]] && serveFile "$file" "$CLIENT" || console "!>" "$file not found"
              ;;
  esac
  echo -e "\r\n" > $CLIENT
}

httpheader(){
  case $1 in 
    200) echo -e "HTTP/1.0 200 OK\r\n" 
         ;;
    404) echo -e "HTTP/1.0 404 OK\r\n"
         ;;
  esac
}

serveFile(){
  file="$1"; CLIENT="$2"
  [[ ! -f "$file" ]] && console "->" "file $file not found" && httpheader 404 > $CLIENT && return 1
  httpheader 200 > $CLIENT
  console "->" "serving $file"
  if [[ -f "$file.handler" ]]; then                      # and if a file(.handler) file is found
    cat "$file" | fetch > $CLIENT 
  else cat "$file" > $CLIENT; fi # or just output the file (images/css/eg)
}


cleanup(){
  [[ -f "$TMPFILE" ]] && rm "$TMPFILE"
  echo "server stopped"
  exit
}

fetch(){
  IFS=''; cat - | while read line; do 
    for k in "${!args[@]}"; do [[ "$k" == "0" ]] && continue;
      value="$( echo "${args["$k"]}" | sed -e 's/[\/&]/\\&/g' | sed "s/'/\"/g" )"; eval "$k="$value";"
    done; 
    line="$(eval "echo \"$( echo "$line" | sed 's/"/\\"/g')\"")"; echo "$line" # process bash in snippet
  done
}

trap cleanup SIGINT
if [[ -n "$1" ]]; then "$@"; else start; fi
