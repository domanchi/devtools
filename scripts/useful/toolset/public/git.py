#!/bin/python

from common import AbstractTool, output_tools, OutputAlignment

class GitReferenceTool(AbstractTool):
    """ git command references """

    def __init__(self):
        self.reference = {
            "git branch -m <new_name>" : "renames current branch",
            "git branch -t upstream/branch-name local-branch-name" : "track remote branch",
            "git config --global alias.<alias_name> '<git command to run>'":
                "git alias",
        }

        self.analysis = {
            "git shortlog -s -n": "view contributors",
            "git log -p --author=\"<author name\"": "view diff of all commits by author",
        }

        self.tagging = {
            "git tag -a <tag_name> -m <message>": "creates a tag with a given message",
            "git tag -a <tag_name> <commit_hash>": "creates tag on specific commit",
            "git push origin <tag_name>": "push a tag (not in default git push)",
            "git tag <tag_name>": "lightweight tag, no other info is stored",
            "git show <tag_name>": "view a given tag"
        }

        super(GitReferenceTool, self).__init__()

    def usage(self):
        print "Quick Reference:"
        output_tools(self.reference, mode=OutputAlignment.LEFT, spacing=3)        
        print
 
        print "Git Tagging:"
        output_tools(self.tagging, mode=OutputAlignment.LEFT, spacing=3)
        print

        print "Investigative Work:"
        output_tools(self.analysis, mode=OutputAlignment.LEFT, spacing=3) 
        print

        print "-" * 35 + " Whoops... " + "-" * 35
        print "Undo git fetch:"
        print "   git remote remove A"
        print "   git remote add A <path/to/repo>"
        print
        print "Delete git tag:"
        print "   git tag -d <tag_name>"
        print "   git push origin :refs/tags/<tag_name>"
