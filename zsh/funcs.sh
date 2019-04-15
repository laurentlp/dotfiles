# Add ssh config for local server
# theuniverse.ca
tt() {
    myip="$(ipconfig getifaddr en0)"
    if [ $myip = "192.168.2.181" ]
    then
        ssh -p 65476 laurentlp@192.168.2.175
    else
        ssh -p 65476 laurentlp@theuniverse.ca
    fi
}
