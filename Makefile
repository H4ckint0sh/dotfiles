grant_permissions:
	chmod +x ./macsetup
	chmod +x ./functions
	chmod +x ./linkfolders
	chmod +x ./install
	chmod +x ./import-defaults.sh
mac_setup: grant_permissions ./macsetup ./linkfolders ./install ./functions ./import-defaults.sh
