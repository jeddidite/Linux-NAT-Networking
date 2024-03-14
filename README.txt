routingsetup.sh
	1. Run this with sudo bash ./routingsetup.sh
	2. this will set up a NAT between your external nic and internal nic, allowing internet access to attached devices or virtual machines. 
	3. This will work with the PXE server package, as well as others where you have custom DHCP settings.
 
wireless_bridge.sh
	1. Run this with sudo bash ./wireless_bridge.sh 
	2. This will set up a NAT between your external NIC and internal NIC similiar to the above, and make the setting persistant after reboot. 
	3. This will not work with custom DHCP settings like the one in PXE server project. 

unrouting.sh
	1. Run with sudo bash ./unrouting.sh
	2. In case there was a mistake, and you ran one of the two above, and now your network is down. You can run this to undue what the previous scripts did.  
