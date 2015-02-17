ls ${a} | grep '.torrent' | while read -r event
do
	file=${a}/${event}
        if [ -e "${file}" ] 
        then
                if [ ! -d "${c}" ]
                then
                        mkdir ${c}
                fi
                mount -t afp ${b} ${c} 2> /dev/null
		mv ${file} ${d} 2> /dev/null 
	fi
done