#!/bin/bash
#
# matrix: matrix-ish display for Bash terminal
# Author: Brett Terpstra 2012 <http://brettterpstra.com>
# Contributors: Lauri Ranta and Carl <http://blog.carlsensei.com/>
#
# A morning project. Could have been better, but I'm learning when to stop.
# Adapted By: James Shane 2020 <http://jamesshane.com>

### Customization:
blue="\033[0;34m"
brightblue="\033[1;34m"
cyan="\033[0;36m"
brightcyan="\033[1;36m"
green="\033[0;32m"
brightgreen="\033[1;32m"
red="\033[0;31m"
brightred="\033[1;31m"
white="\033[1;37m"
black="\033[0;30m"
grey="\033[0;37m"
darkgrey="\033[1;30m"
yellow="\033[0;33m"
brightyellow="\033[1;33m"
# Choose the colors that will be used from the above list
# space-separated list
# e.g. `colors=($green $brightgreen $darkgrey $white)`
colors=($green $brightgreen)
colors=($red $brightred)
colors=($yellow $brightyellow)
colors=($grey $darkgrey)
debugcolors=($blue $brightblue)
### End customization

### Do not edit below this line
spacing=5 #${1:-5} # the likelihood of a character being left in place
scroll=1 #${2:-1} # 0 for static, positive integer determines scroll speed
screenlines=$(expr `tput lines` - 1 + $scroll)
screencols=$(expr `tput cols` / 2 - 1)

# chars=(a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 0 1 2 3 4 5 6 7 8 9 ^)
# charset via Carl:
chars=(ｱ ｲ ｳ ｴ ｵ ｶ ｷ ｸ ｹ ｺ ｻ ｼ ｽ ｾ ｿ ﾀ ﾁ ﾂ ﾃ ﾄ ﾅ ﾆ ﾇ ﾈ ﾉ ﾊ ﾋ ﾌ ﾍ ﾎ ﾏ ﾐ ﾑ ﾒ ﾓ ﾔ ﾕ ﾖ ﾗ ﾘ ﾙ ﾚ ﾛ ﾜ ﾝ)

count=${#chars[@]}
colorcount=${#colors[@]}

trap "tput sgr0; clear; exit" SIGTERM SIGINT

if [[ $1 =~ '-h' ]]; then
	echo "Display a Matrix(ish) screen in the terminal"
	echo "Usage:		matrix  [TESTTYPE] [DEBUG]" #[SPACING [SCROLL]]
	echo "Example:	matrix m" #echo "Example:	matrix 100 0 m"
	echo "TESTTYPE: m=memory (defualt), c=cpu"
	echo "DEBUG: 1=show debug info in blue"
	exit 0
fi

testtype=$1
if [[ $testtype == "" ]]
then
	testtype="m"
fi

isdebug=$2

clear
tput cup 0 0
#print anything in line here

if [[ $isdebug != "" ]]
then
	printf "${debugcolors[$RANDOM%$colorcount]}$spacing | $scroll | $testtype "
fi

while :
	do for i in $(eval echo {1..$screenlines})
		do for i in $(eval echo {1..$screencols})
			do rand=$(($RANDOM%$spacing))
				case $rand in
					0)
						printf "${colors[$RANDOM%$colorcount]}${chars[$RANDOM%$count]} "
						;;
					1)
						printf "  "
						;;
					*)
						printf "\033[2C"
						;;
				esac
			done
			#printf "\n"

			sleep 1
			if [[ $testtype == "m" ]]
			then
            	mt=$(free -m | awk 'NR==2{printf "%i", (($2-$7)/$2)*100 }')
			fi
			if [[ $testtype == "c" ]]
			then
            	mt=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{printf "%i", (100 - $1)}')
			fi
			if [[ $isdebug != "" ]]
			then
				printf "${debugcolors[$RANDOM%$colorcount]}$testtype=$mt "
			fi
            case 1 in
                $(($mt > 90)))
                    colors=($red $brightred)
                    ;;

                $(($mt > 70)))
                    colors=($yellow $brightyellow)
                    ;;

                $(($mt > 0)))
                    colors=($green $brightgreen)
                    ;;

                *)
                    colors=($grey $darkgrey)
                    ;;
            esac
		done
		#tput cup 0 0
	done