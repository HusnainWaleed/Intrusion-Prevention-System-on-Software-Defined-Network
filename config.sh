#Snort mainly has 4 dependencies:
#pcap, PCRE, Libdnet, DAQ, which can be installed by the following commands.
#The build-essential package should be installed first (usually the system is already installed):
#Java
sudo apt-get install -y build-essential

#Then install pcap, PCRE and Libdnet with the following commands:
sudo apt-get install -y libpcap-dev libpcre3-dev libdumbnet-dev

#DAQ also has some dependencies to install, enter the following command:
sudo apt-get install -y bison flex

#Since the installation of snort on Ubuntu needs to download some software packages, create the snort_src folder and download the relevant software packages to this folder:
mkdir ~/snort_src
cd ~/snort_src

#Then download DAQ in this folder, and perform the following steps to download DAQ version 2.0.6:
cd ~/snort_src
wget https://snort.org/downloads/snort/daq-2.0.6.tar.gz
tar -xvzf daq-2.0.6.tar.gz
cd daq-2.0.6
./configure
make
sudo make install

#----------------3.2 Install snort-----------------
#Before installing snort on Ubuntu, you also need to install the zlibg library, execute the following command:
sudo apt-get install -y zlib1g-dev liblzma-dev openssl libssl-dev

#Then install the library files related to Nghttp2:
sudo apt-get install -y libnghttp2-dev

#Now, we can download the snort tarball and install it Note that 
#to enable its unix socket communication function, that is, add
#the suffix --enable-control-socket after ./configure, otherwise
#the unix socket communication function will not be available:
tar -xvzf snort-2.9.9.0.tar.gz
./configure --enable-control-socket
make&&make install

#Then update a dependent library and create a soft link:
sudo ldconfig
sudo ln -s /usr/local/bin/snort  /usr/sbin/snort

#Enter the snort -V command in the terminal and see the following 
#display, indicating that the installation is successful:


#----------------3.3 Configuring snort---------------------------
# Create snort user and user group so that snort doesn't run as root:
sudo groupadd snort
sudo useradd snort -r -s /sbin/nologin -c SNORT_IDS -g snort
# Create snort related folders:
sudo mkdir /etc/snort
sudo mkdir /etc/snort/rules
sudo mkdir /etc/snort/rules/iplists
sudo mkdir /etc/snort/preproc_rules
sudo mkdir /usr/local/lib/snort_dynamicrules
sudo mkdir /etc/snort/so_rules
# Create a file to store snort matching rules and ip addresses
sudo touch /etc/snort/rules/iplists/black_list.rules
sudo touch /etc/snort/rules/iplists/white_list.rules
sudo touch /etc/snort/rules/local.rules
sudo touch /etc/snort/sid-msg.map
# create log directory
sudo mkdir /var/log/snort
sudo mkdir /var/log/snort/archived_logs
# Adjust permissions
sudo chmod -R 5775 /etc/snort
sudo chmod -R 5775 /var/log/snort
sudo chmod -R 5775 /var/log/snort/archived_logs
sudo chmod -R 5775 /etc/snort/so_rules
sudo chmod -R 5775 /usr/local/lib/snort_dynamicrules
# Change the ownership of these files
sudo chown -R snort:snort /etc/snort
sudo chown -R snort:snort /var/log/snort
sudo chown -R snort:snort /usr/local/lib/snort_dynamicrules

#Run the following command to copy the relevant configuration files to the folder we just created:
cd ~/snort_src/snort-2.9.9.0/etc/
sudo cp *.conf* /etc/snort
sudo cp *.map /etc/snort
sudo cp *.dtd /etc/snort
 
cd ~/snort_src/snort-2.9.9.0/src/dynamic-preprocessors/build/usr/local/lib/snort_dynamicpreprocessor/
sudo cp * /usr/local/lib/snort_dynamicpreprocessor/

#After completion, we need to configure snort's configuration file
#snort.conf, modify the value of ipvar HOME_NET according to actual
#needs, modify it to the network that needs to be protected, and
#modify the following values, so that snort reads us at startup 
#Relevant files just created:
var RULE_PATH /etc/snort/rules
var SO_RULE_PATH /etc/snort/so_rules
var PREPROC_RULE_PATH /etc/snort/preproc_rules
var WHITE_LIST_PATH /etc/snort/rules/iplists
var BLACK_LIST_PATH /etc/snort/rules/iplists

#In order to test we first comment out
#all include $RULE_PATH in snort.conf, 
#except include $RULE_PATH/local.rules,
#so that we can manually add custom in 
#/etc/snort/rules/local.rules file when
#testing the rules of snort working.

