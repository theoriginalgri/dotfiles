#!/bin/sh

cd /tmp

function install_cert() {
	CERT_URL=$1
	CERT_HASH=$2
	CERT_NAME=$(basename $CERT_URL)
	CERT_PATH=/tmp/$CERT_NAME

	wget --no-check-certificate $CERT_URL
	
	if [ $? -gt 0 ]; then
		echo "Failed to download certificate from $CERT_URL"
		return
	fi
	
	# Do checksum tests
	FILE_HASH=$(sha256sum $CERT_PATH | awk '{print $1;}')
	if [ "$FILE_HASH" != "$CERT_HASH" ]; then
		echo "Invalid sha256 sum for $CERT_NAME"
		return
	fi

	# Install certificate in OSX System Keychain
	sudo security add-trusted-cert -d -r trustAsRoot -k \
		/Library/Keychains/System.keychain \
		$CERT_PATH

	# Install certificate in strongswan calist
	sudo cp $CERT_PATH /usr/local/etc/ipsec.d/cacerts/
	
	# Remove the certificate from tmp
	rm $CERT_PATH
}

install_cert https://www.cacert.org/certs/root.crt \
	c0e0773a79dceb622ef6410577c19c1e177fb2eb9c623a49340de3c9f1de2560
install_cert https://www.cacert.org/certs/class3.crt \
	f5badaa5da1cc05b110a9492455a2c2790d00c7175dcf3a7bcb5441af71bf84f
