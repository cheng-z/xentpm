
#----------automated steps after extracting the .jar file----------

#!/bin/bash

#create a tpm agent dir
LOG="/tmp/xen_tpm_agent.log"
BASE="/opt/xensource/tpm"
PLUGIN="/etc/xapi.d/plugins/"

if  [ -f $LOG ];
    then
    echo "" > $LOG
fi

if ! [ -d $BASE ];
    then 
    mkdir -p $BASE
    echo `date` >> $LOG 
    echo "Xen TPM agent setup starting" >> $LOG 
    else
    rm -rf /opt/xensource/tpm/*
fi 

## create public key
#openssl rsa -in /etc/ssh/ssh_host_rsa_key -pubout > $BASE/xen.pub
#if [ $? -ne 0 ];
#    then
#    echo  "Setup:Error Creating Xen server public key" | tee -a $LOG 
#    exit
#    else
#    echo  "Setup: Xen server public key created in PAM" | tee -a $LOG 
#fi
#

./generateAik

if [ $? -ne 0 ];
    then
    echo "Setup:Error generating defaul AIK" | tee -a $LOG 
    exit
fi

echo  "Setup: Success" | tee -a $LOG 

## copy schema file
cp -f xenaik.xml /opt/xensource/tpm/

## copy all executables in /opt/xensource/tpm
#cp -f mkcert      $BASE
#cp -f aikpublish  $BASE
cp -f generateAik  $BASE
cp -f aikrespond  $BASE
cp -f xenquote    $BASE

# copy python plugins in the /etc/xapi.d/plugins
cp -f tpmChallangeAik       $PLUGIN
cp -f tpmGetAttestationKey  $PLUGIN
cp -f tpmGetQuote           $PLUGIN
