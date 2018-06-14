#!/bin/python

from common import AbstractTool, output_tools

class WebAnalysisTool(AbstractTool):
    """ Tools for getting more information about hosts online """

    def __init__(self):
        self.detail = {
           "traceroute": TracerouteTool(),
        }

    def usage(self):
        print "These tools are useful to find out more information about web services."
        output_tools(self.detail, 23)

class TracerouteTool(AbstractTool):
    """ See every step a packet takes to its destination """
    
    def usage(self):
        print "Uses:"
        print "   --resolve-hostnames <url/ip> : try and humanize the IP, if known"

