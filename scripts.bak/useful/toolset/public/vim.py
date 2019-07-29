#!/bin/python

from common import AbstractTool, output_tools, OutputAlignment

class VimReferenceTool(AbstractTool):
    """ vim command references """

    def __init__(self):
        self.detail = {
            "set list" : "view all special hidden characters",
            "diffthis" : "set file to be used in diffing. Need to be set per file.",
            "Gblame"   : "[PLUGIN] git blame in vim"
        }

    def usage(self):
        print "Editor Commands (preceded by ':'):"
        output_tools(self.detail, spacing=3, mode=OutputAlignment.LEFT)
        print

        print "Code Folding:"
        print "   set fdm=indent => sets fold method to the indent."
        print "   zc => close fold."
        print "   zo => open fold."
        print

        print "Shell Commands:"
        print "   :%! :"
        print "     => % means apply to whole file"
        print "     => ! means execute in shell, and capture output in vim"
        print
        print "   Examples:"
        print "      :%!jq '.' => convert entire json file to nicer format"
        print
        
        print "From CLI:"
        print "   vim +<command, no colon> <file>"
