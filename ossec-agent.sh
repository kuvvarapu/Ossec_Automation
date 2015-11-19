#!/bin/bash -x
#Author: kiku
#This script is used to install and configure ossec agent
#Date:Nov 19 /2015


#Generate hask key in ossec server and add it here
hash_key="MDAxIGFnZW50MSAxOTIuMTY4LjIuOCBjMGRiNDNhNmQ2MWQzYTYwMDk4ZmZhZTQwMjc1Njg0MDdjMTQ1ZTFkMjQ0ZmVkN2UxOWJlNGI2ODg5ZmFkMjM1" 
serverip="10.1.2.100"  #Ossec Server IP
LogFile="/var/log/postinstall.log"
exec 1<> $LogFile

wget_check(){
if [ -x /bin/wget ]
	then
	echo "wget installed"
else
	yum install wget -y
fi
}

#Automating the ossec installation process and configuring
ossec_configure(){
cd $folder
./install.sh <<EOF
en
<Cr>
agent
/var/ossec
$server
y
y
n
<Cr>
<Cr>
EOF
}

#Used to add the agent to the server
manage_ossec(){
#Specify the HASH key ,Generated from Ossec-server

/var/ossec/bin/manage_agents <<EOF
I
$hash_key
y
<Cr>
q
EOF
}


#Downloading Ossec-agent 
ossec_install(){
wget_check
wget $Link
tar -xvzf $filename
ossec_configure
manage_ossec
echo "Ossec agent Installation completed"
/var/ossec/bin/ossec-control restart
}


Link="https://www.dropbox.com/s/sir057v8hcncv62/ossec-hids-2.8.2.tar.gz"
#This will hold the name of the download file name
filename=$(basename $Link)
#This will hold the name of the extracted folder name
folder=${filename:0:16}
#checking for previous folders
if [ -d "$folder" ];then
	echo "Package is already downloaded and extracted"
else
	echo "package is dowloading"
	echo "$folder"
    ossec_install
fi

exec 1>&-
