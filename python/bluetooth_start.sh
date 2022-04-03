sudo rfcomm bind rfcomm99 00:1D:A5:68:98:8A
sudo rfcomm connect /dev/rfcomm99 00:1D:A5:68:98:8A 1 & sudo rfcomm release /dev/rfcomm99 & sleep 10 && sudo chmod 666 /dev/rfcomm99