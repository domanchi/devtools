#!/usr/bin/python2.7
try:
    import argcomplete
except:
    argcomplete = None

import argparse
import inspect
import subprocess
import sys

from common import AbstractTool, output_tools
import private
import public

class ArgumentParserError(Exception): pass

class CustomArgumentParser(argparse.ArgumentParser):
    def error(self, message):
        raise ArgumentParserError

class MainTool(AbstractTool):

    def getGroupRoutes(self):
        # Top level navigation
        groupRoutes = {}
        for name,obj in inspect.getmembers(private) + inspect.getmembers(public):
            if inspect.isclass(obj) and inspect.getmodule(obj).__name__ != "common" and \
               obj.__name__.endswith("Tool"):
                name = inspect.getmodule(obj).__name__.split('.')[-1]
                groupRoutes[name] = obj()
                obj.file = inspect.getfile(obj)[:-1]
        return groupRoutes

    def usage(self):
        print "Usage: toolset <query>"
        print "This is a listing of different CLI tools you use to perform various tasks."
        print "Current supported group names include:"
        output_tools(self.modules, 13)
        print
        print "Optional Flags:"
        print "    -e | --edit  : opens the file for editing"

    def main(self, args):
        parser = CustomArgumentParser(add_help=False)

        self.modules = self.getGroupRoutes()

        # Adding all allowed paths
        allowedRoutes = self.modules.copy()
        for group in self.modules:
            allowedRoutes.update({key : self.modules[group].detail[key] \
                for key in self.modules[group].detail \
                if type(self.modules[group].detail[key]) != type("")})

            # NOTE: Currently only allows one layer of nesting
            for subtopic in self.modules[group].detail:
                if type(self.modules[group].detail[subtopic]) != type(""):
                    allowedRoutes[subtopic].file = self.modules[group].file

        parser.add_argument("query", choices=allowedRoutes)
        parser.add_argument("-e", "--edit", help="edit the file that contains this note", action="store_true")

        # Untested (and not currently working lol)
        # subparsers = parser.add_subparsers()
        # for group in self.modules:
            # self.modules[group].parser(subparsers)

        if argcomplete:
            argcomplete.autocomplete(parser)

        try:
            args = parser.parse_args()
        except ArgumentParserError:
            self.usage()
            return

        if args.edit:
            if args.query not in self.modules:
                line_start = '+/"class ' + allowedRoutes[args.query].__class__.__name__ + '"'
            else:
                line_start = ""

            shell_cmd = "vim %s %s" % (line_start, allowedRoutes[args.query].file)
            subprocess.call(shell_cmd, shell=True) 
        elif type(allowedRoutes[args.query]) == type(""):
            print allowedRoutes[args.query]
        else:
            allowedRoutes[args.query].main(args)

if __name__ == "__main__":
    (MainTool()).main(sys.argv)

