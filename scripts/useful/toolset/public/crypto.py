#!/bin/python

from common import AbstractTool, output_tools

class CryptoTool(AbstractTool):
    """ Tools for using various crypto protections easily """ 

    def __init__(self):
        self.detail = {
            "gpg" : GPG(),
            "pki" : PKI()
        }

    def usage(self):
        print "These tools are useful to find out info about your computer."
        output_tools(self.detail, 15)


class GPG(AbstractTool):
    """ Public/private key management """
    def usage(self):
        print "Uses:"
        print "  * Verify a file"
        print "    `gpg --verify <.sig file> <file-to-verify>`"
        print "    This uses the signature file to verify the file."
        print "    NOTE: Make sure to import the public key signature first!"
        print
        print "  * Importing a signature"
        print "    `gpg --import <public-key-file>`"
        print "    This adds a public key to your trusted key-ring."

class PKI(AbstractTool):
    """ Public Key Infrastructure: this generates public/private keypairs on a linux system. """
    def usage(self):
        print "1. Generate private key."
        print "   openssl genpkey -algorithm RSA -out private_key.pem -pkeyopt rsa_keygen_bits:2048"
        print "2. Prevent other users from reading key. (prevent (g)roups and (o)ther from reading (-r)"
        print "   chmod go-r private_key.pem"
        print "3. Extract public key from private key."
        print "   openssl rsa -pubout -in private_key.pem -out public.key.pem"
