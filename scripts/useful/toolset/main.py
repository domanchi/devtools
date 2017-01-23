#!/usr/bin/python
import argcomplete
import argparse
import sys
import inspect

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
        return groupRoutes

    def usage(self):
        print "Usage: toolset <query>"
        print "This is a listing of different CLI tools you use to perform various tasks."
        print "Current supported group names include:"

        output_tools(self.modules, 13)

    def main(self, args):
        parser = CustomArgumentParser(add_help=False)

        self.modules = self.getGroupRoutes()

        # Adding all allowed paths
        allowedRoutes = self.modules.copy()
        for group in self.modules:
            allowedRoutes.update(self.modules[group].detail)

        parser.add_argument("query", choices=allowedRoutes)

        # Untested (and not currently working lol)
        # subparsers = parser.add_subparsers()
        # for group in self.modules:
            # self.modules[group].parser(subparsers)

        argcomplete.autocomplete(parser)

        try:
            args = parser.parse_args()
        except ArgumentParserError:
            self.usage()
            return

        query = vars(args)['query']
        if type(allowedRoutes[query]) == type(""):
            print allowedRoutes[query]
        else:
            allowedRoutes[query].main(vars(args))

if __name__ == "__main__":
    (MainTool()).main(sys.argv)

