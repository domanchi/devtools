#!/bin/python

from common import AbstractTool, output_tools

class VimReferenceTool(AbstractTool):
    """ vim command references """

    def __init__(self):
        self.detail = {
            "vim +<command, no colon> <file>" : "run commands on CLI upon open",
        }

    def usage(self):
        output_tools(self.detail, 45)        

