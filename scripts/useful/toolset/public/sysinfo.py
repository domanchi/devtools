#!/bin/python

from common import AbstractTool

class SystemInformationTool(AbstractTool):
    """ Tools for getting general system information """ 

    def usage(self):
        print "These tools are useful to find out info about your computer."
        print "   uname -a           : display current system"
        print "   groups <username>  : display groups that the current user is in."
        print "   gpasswd            : group management tool."
        print "   cat /etc/*-release : display Linux version."
