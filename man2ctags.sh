#!/bin/bash
# GrepSuzette
progName="$( basename "$0" )"
version=0.1

warn() { local fmt="$1"; shift; printf "$progName: $fmt\n" "$@" >&2; }
die () { local st="$?"; warn "$@"; exit "$st"; } 
define(){ IFS='\n' read -r -d '' ${1} || true; }

define helpString <<EOF
$progName v$version - Generate ctags for vim help files (doc/xxx.txt)
This allows showing a table of contents in tagbar.
Will output the tags for a man page to stdout
Public domain, 2017 GrepSuzette
Syntax: $progName inputfile
EOF

if [[ $# != 1 || $1 = -* ]]; then
    echo "$helpString"
    exit
else
    inputfile="$1"
    [[ -f $inputfile ]]   || die "'$inputfile' is not a file"
    [[ ! -d $inputfile ]] || die "'$inputfile' is a directory"
    [[ -r $inputfile ]]   || die "'$inputfile' is not readable"
fi

# turn case detection ON in regex
shopt -u nocasematch

# big title being preceded by =======
echo -e "!_TAG_FILE_FORMAT\t2"

# Bash, ksh93, mksh
unset -v arr i
while IFS= read -r; do
    filelines[i++]=$REPLY
done <"$inputfile"
[[ $REPLY ]] && filelines[i++]=$REPLY # Append unterminated data line, if there was one.

where=0
ln=1

for currentline in "${filelines[@]}"; do
    if [[  "$currentline" =~ ^(\.SH )(.*)$ ]] \
    ; then
        offset=""
        found="${BASH_REMATCH[2]}"
        found=${found,,}
        found=${found^}
        found=${found%:}
        echo -e "$offset$found\t$inputfile\t:$ln<CR>;\"\ts\tline:$ln\tsection:TOC"
    fi
    previousline="$currentline"
    currentline="$nextline"
    let ln+=1
done
