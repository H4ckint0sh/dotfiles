grant_permissions:
	chmod +x ./macsetup
	chmod +x ./fishsetup
	chmod +x ./functions
	chmod +x ./linkfolders
	chmod +x ./install
mac_setup: grant_permissions ./macsetup ./linkfolders ./install ./fishsetup ./functions
