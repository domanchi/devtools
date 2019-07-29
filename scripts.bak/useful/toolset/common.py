#!/bin/python

class AbstractTool(object):
    def __init__(self):
        self.detail = {}

    def parser(self, subparser):
        # Implement this function, if subparsing is needed.
        # https://docs.python.org/2/library/argparse.html#sub-command
        return None

    def usage(self):
        raise NotImplementedException("abstract class")

    def main(self, args):
        self.usage()

class OutputAlignment:
    CENTER = "center"
    LEFT = "left"

import inspect
def output_tools(tools_set, spacing, mode=OutputAlignment.CENTER):
    # tools_set is a dictionary of keys => objects.
    # This will output them, in sorted key order, with their class description.
    # NOTE: spacing is suggested to be an odd number when 
    #       mode == OutputAlignment.CENTER, for aesthetic reasons.

    sorted_keys = sorted(tools_set)
    for key in sorted_keys:
        if type(tools_set[key]) == type(""):
            description_str = tools_set[key]
        else:
            description_str = inspect.getdoc(tools_set[key].__class__)

        if mode == OutputAlignment.CENTER:
            print ("{:^%d}: {}" % spacing).format(key, description_str)
        elif mode == OutputAlignment.LEFT:
            print "%s%s: %s" % (" " * spacing, key, description_str)
        else:
            raise Exception("Unknown OutputAlignment!")

class BashColor(object):
    RED = "[0;31m"
    GREEN = "[0;32m"
    YELLOW = "[1;33m]"

def _(message, color=None):
    # This is normally used for internationalization, but it's not like I'm going
    # to make my notes for everyone. So I just used this as a color mechanism.

    if color == None:
        return message
    return "\x1b" + color + message + "\x1b[m"
