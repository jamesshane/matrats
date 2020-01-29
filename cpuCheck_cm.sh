#!/bin/bash

#sh -c 'L=$$; echo $L;exec cmatrix -b -s&' #initial test to get pid

isdebug=$1

while true; do
	
    mt=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{printf "%i", (100 - $1)}')
	case 1 in
		$(($mt > 90)))
			c="red"
			;;

		$(($mt > 70)))
			c="yellow"
			;;

		$(($mt > 0)))
			c="green"
			;;

		*)
			c="white"
			;;
	esac
	if [[ $isdebug == "-d" ]]
	then
		echo "$mt | $c | $prev" #debug
	fi
	sleep 5
	if [[ $prev != $c ]] 
	then
		prev=$c
		#echo "changed!" #debug
		if [[ $bg_PID != "" ]] 
		then
			kill -15 $bg_PID
		fi
		cmd="cmatrix -n -a -C $c"
		$cmd &
		bg_PID=$!
	fi
done

