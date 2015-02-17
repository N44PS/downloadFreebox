# downloadFreebox

Torrents downloaded on your computer will automatically be added to your Freebox NAS on your local network. You only need two files :

## Only two files

#### watch.sh

```bash
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
```

* List the content of the watched folder
* grab all .torrent file (There actually should be only one .torrent file at a time).
* For each .torrent file, if the file still exists
* Create a folder to be mounted to
* If afp folder isn't mounted, mount it on the previous folder
* Move the .torrent file into the mounted folder

#### com.freebox.download.plist

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" 
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>com.freebox.download</string>
	
	<key>ProgramArguments</key>
	<array>
		<string>${e}</string>
	</array>    
	
	<key>WatchPaths</key>
	<array>
		<string>${a}</string>
	</array>
	<key>RunAtLoad</key>
		<true/>
</dict>
</plist>
```

* This file actually runs the watch.sh script when there is a change to the watch folder
* RunAtLoad set to true for starting the processus on boot

## Where to put them ?
- Put the .sh file inside your $PATH and make it executable
- Put the .plist file inside /Library/LaunchDaemons

#### Don't forget to replace the placeholder with real values

```
# ${a} folder to watch          : e.g. /Users/xxx/Downloads
# ${b} folder to create         : e.g. /Volumes/ Disque\ dur
# ${c} afp folder to mount      : e.g. afp://192.168.0.254/Disque\ dur
# ${d} Freebox watched folder   : e.g. /Volumes/ Disque\ dur/Téléchargement/À\ Télécharger
# ${e} Path to the script       : e.g. /Users/xxx/bin/watch.sh
```

#### Reboot and enjoy !
      