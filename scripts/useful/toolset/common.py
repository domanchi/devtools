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

import inspect
def output_tools(tools_set, column_spacing):
    # tools_set is a dictionary of keys => objects.
    # This will output them, in sorted key order, with their class description.
    # NOTE: column_spacing is suggested to be an odd number, for
    #       aesthetic reasons.

    sorted_keys = sorted(tools_set)
    for key in sorted_keys:
        if type(tools_set[key]) == type(""):
            description_str = tools_set[key]
        else:
            description_str = inspect.getdoc(tools_set[key].__class__)

        print ("{:^%d}: {}" % column_spacing) \
            .format(key, description_str)

