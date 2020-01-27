#!/bin/bash

#sh -c 'L=$$; echo $L;exec cmatrix -b -s&' #initial test to get pid

while true; do
	#mt=$(free -m | awk 'NR==2{printf "Mem: %s/%sMB (%.2f%%)\n", $2-($4),$2,($2-($4))*100/$2 }') #getting memory
	mt=$(free -m | awk 'NR==2{printf "%i", ($2-($4))*100/$2 }')
	case 1 in
		$(($mt > 95)))
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
	#echo "$mt | $c | $prev" #debug
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

