#!/bin/bash
NEED='@'

DIR=https://github.com/humfr3y/bashwalker/blob/main/walk.txt #change links
RESET=https://github.com/humfr3y/bashwalker/blob/main/reset.txt #change link

WAY=(99 98 97 96 95) # UP DOWN LEFT RIGHT CENTER(@)

ROWS=70; COLS=20
LIMIT=$((ROWS*$COLS))

MAX=500
count=1
RANGE=$LIMIT

MAX_FOOD=26
count_FOOD=1
ATE=0

function showMap() {
if [ -f "$DIR" ]
then
    import=`cat $DIR | tr -d \r\n`
fi
    for ((i=0; i<$COLS; i++)) do
    for ((j=0; j<$ROWS; j++)) do
    ID=$((i*$ROWS+j))
    VARIABLE=${import:$ID:1}
    printf $VARIABLE
    if [ "$VARIABLE" == "$NEED" ]
    then
    WAY[0]=$((ID-$ROWS)); WAY[1]=$((ID+$ROWS)); WAY[2]=$((ID-1)); WAY[3]=$((ID+1)); WAY[4]=$((ID));
    fi
    done
    echo
    done
}

showMap

while true; do
    read -r -n 3 key
    clear
    case "$key" in
        $'\e[A')
        HASH=${import:${WAY[0]}:1}
        if [[ ${WAY[0]} -gt -1 && "$HASH" != "#" ]]
        then
        if [ ${import:${WAY[0]}:1} == "o" ]
        then
        ATE=$((ATE+1))
        fi
        result= sed -i "s/\(.\{${WAY[0]}\}\)./\1@/; s/\(.\{${WAY[4]}\}\)./\1./" $DIR
        echo "$result" >> "$DIR"
        fi
        ;;
        $'\e[B')
        HASH=${import:${WAY[1]}:1}
        if [[ ${WAY[1]} -lt $LIMIT && "$HASH" != "#" ]]
        then
        if [ ${import:${WAY[1]}:1} == "o" ]
        then
        ATE=$((ATE+1))
        fi
        result= sed -i "s/\(.\{${WAY[1]}\}\)./\1@/; s/\(.\{${WAY[4]}\}\)./\1./" $DIR
        echo "$result" >> "$DIR"
        fi
        ;;
        $'\e[C') #right
        HASH=${import:${WAY[3]}:1}
        if [[ ${WAY[3]} -lt $LIMIT && "$HASH" != "#" ]]
        then
        if [ ${import:${WAY[3]}:1} == "o" ]
        then
        ATE=$((ATE+1))
        fi
        result= sed -i "s/\(.\{${WAY[3]}\}\)./\1@/; s/\(.\{${WAY[4]}\}\)./\1./" $DIR
        echo "$result" >> "$DIR"
        fi
        ;;
        $'\e[D') #left
        HASH=${import:${WAY[2]}:1}
        if [[ ${WAY[2]} -gt -1 && "$HASH" != "#" ]]
        then
        if [ ${import:${WAY[2]}:1} == "o" ]
        then
        ATE=$((ATE+1))
        fi
        result= sed -i "s/\(.\{${WAY[2]}\}\)./\1@/; s/\(.\{${WAY[4]}\}\)./\1./" $DIR
        echo "$result" >> "$DIR"
        fi
        ;;
        *)
        ATE=0
        imp_reset=`cat $RESET | tr -d \r\n`
        echo "$imp_reset" > "$DIR"
        while [ "$count" -le $MAX ] #hash generation
        do
            number=$RANDOM
            number=$((number % $RANGE))
            sed -i "s/\(.\{$number\}\)./\1#/" $DIR
            count=$((count + 1))
        done
        count=1
        while [ "$count_FOOD" -le $MAX_FOOD ] #food generation
        do
            number=$RANDOM
            number=$((number % $RANGE))
            while [ ${import:$number:1} == "#" ]
            do
                number=$RANDOM
                number=$((number % $RANGE))
            done
            sed -i "s/\(.\{$number\}\)./\1o/" $DIR
            count_FOOD=$((count_FOOD + 1))
        done
        count=1
        count_FOOD=1
        ;;
    esac
    tput sgr0
    echo "Map: "
    showMap
    echo "Coordinates: X:$((${WAY[4]}%$ROWS)) Y:$((${WAY[4]}/$ROWS))         Ate $ATE fruits from $MAX_FOOD"

    done

# while [ "$VARIABLE" != "$NEED" ]; do
#     sleep 0.3
#
#     VARIABLE=${import:$symbol_num:1}
#     echo $VARIABLE
#     symbol_num=$((symbol_num + 1))
#
#     if [ "$VARIABLE" != "$NEED" ]
# done
