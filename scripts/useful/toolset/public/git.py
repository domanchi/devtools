#!/bin/python

from common import AbstractTool, output_tools

class GitReferenceTool(AbstractTool):
    """ git command references """

    def __init__(self):
        self.detail = {
            "git branch -m <new_name>" : "renames current branch",
            "git config --global alias.<alias_name> '<git command to run>'":
                "git alias"
        }

    def usage(self):
        output_tools(self.detail, 45)        
        
        print
        print "Undo git fetch:"
        print "  git remote remove A"
        print "  git remote add A <path/to/repo>"

