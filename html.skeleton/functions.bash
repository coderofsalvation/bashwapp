declare -A args    # array holding shared bash/html/formvars

initarg(){ # this functions adds a variable to args, and initializes it with a formGET / or default value
  webargs="$args"; var="$1"; defvalue="$2";
  args["$var"]="$(getArg "$var" "$webargs")"
  [[ ${args["$var"]} == "" ]] && args["$var"]="$defvalue"
}

getarg(){ # this function parses a http query string and gets the value of a key
  key="$1"; getargs="$args"
  echo "$getargs" | while read line; do
    key="$(echo "$line" | sed 's/=.*//g')"
    value="$(echo "$line" | sed 's/.*=//g' | urldecode)"
    [[ "$key" == "$1" ]] && echo "$value"
  done
}

urldecode(){
  data="$(cat - | sed 's/+/ /g')"
  printf '%b' "${data//%/\x}"
}

#
# quick and dirty template engine functions
#

replace(){ # quick n dirty multiline search/replace
  source="$1"; dest="$2";
  cat - | while read line; do 
    if echo "$line" | grep "$source" &>/dev/null; then echo "$dest"
    else echo "$line"; fi
  done
}

fetch(){
  IFS=''; cat - | while read line; do 
  for k in "${!args[@]}"; do
    [[ "$k" == "0" ]] && continue;
      value="$( echo "${args["$k"]}" | sed -e 's/[\/&]/\\&/g' | sed "s/'/\"/g" )"
      eval "$k="$value";"
    done; 
    line="$(eval "echo \"$( echo "$line" | sed 's/"/\\"/g')\"")"; # process bash in snippet
    echo "$line"
  done
}
