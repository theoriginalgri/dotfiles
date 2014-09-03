#!/bin/sh

cd /tmp

function install_cert() {
	CERT_URL=$1
	CERT_NAME=$(basename $CERT_URL)
	CERT_PATH=/tmp/$CERT_NAME

	wget --no-check-certificate $CERT_URL
	
	if [ $? -gt 0 ]; then
		echo "Failed to download certificate from $CERT_URL"
		return
	fi

	# Install certificate in OSX System Keychain
	sudo security add-trusted-cert -d -r trustAsRoot -k \
		/Library/Keychains/System.keychain \
		$CERT_PATH

	# Install certificate in strongswan calist
	sudo cp $CERT_PATH /usr/local/etc/ipsec.d/cacerts/
}

install_cert https://www.cacert.org/certs/root.crt
install_cert https://www.cacert.org/certs/class3.crt
