#!/bin/bash

#sh -c 'L=$$; echo $L;exec cmatrix -b -s&'

while true; do
	#mt=$(free -m | awk 'NR==2{printf "Mem: %s/%sMB (%.2f%%)\n", $2-($4),$2,($2-($4))*100/$2 }')
	mt=$(free -m | awk 'NR==2{printf "%i", ($2-($4))*100/$2 }')
	#prev=""
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
	#echo "$mt | $c | $prev"
	sleep 5
	if [[ $prev != $c ]] 
	then
		prev=$c
		#echo "changed!"
		kill -15 $bg_PID
		cmd="cmatrix -C $c"
		$cmd &
		bg_PID=$!
	fi
done

