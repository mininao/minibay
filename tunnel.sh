vnc=`curl --insecure "https://mvx2.esiee.fr/userinfo.php?login=chabertc" | cut -f2 -d:`
echo Votre offset VNC est
echo $vnc
ssh -p 52222 -f -L 5901:mvx2.esiee.fr:$((vnc+5900)) chabertc@mvx2.esiee.fr -N