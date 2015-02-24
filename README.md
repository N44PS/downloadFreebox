# downloadFreebox

Using the [web interface](http://mafreebox.free.fr) Free offers us is wasting a few minutes for nothing and I didn't want to use any plugins or APIs.
I ended up using only two files to automatically add downloaded torrents directly to my Freebox NAS using my local network (AFP).
It actually watches a local folder for .torrent files and move them to a distant folder which is watched by the NAS itself.

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

* The script just grab .torrent files from the wanted folder
* If the AFP folder isn't created, create it then mount it
* Move .torrent files into the AFP watched folder
* The Freebox NAS then proceed by adding them to the download list.

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

* This file runs watch.sh when there is a change to the watched folder
* ```RunAtLoad``` set to true for starting the processus on boot

## Where to put them ?
- Put the .sh file inside your ```$PATH``` and make it executable
- Put the .plist file inside /Library/LaunchDaemons

#### Don't forget to replace the placeholder with real values

```
# ${a} folder to watch          : e.g. /Users/xxx/Downloads
# ${b} folder to create         : e.g. /Volumes/ Disque\ dur 
# ${c} afp folder to mount      : e.g. afp://xxx.xxx.x.x/Disque\ dur /* You can find it in Finder > Go > Connect to server */
# ${d} Freebox watched folder   : e.g. /Volumes/ Disque\ dur/Téléchargement/À\ Télécharger
# ${e} Path to the script       : e.g. /Users/xxx/bin/watch.sh
```

#### Reboot and enjoy !
      
