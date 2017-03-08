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
            "git rebase -i HEAD~X" : "squash commits, where HEAD~X is the branch to rebase from"
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
        print "-" * 33 + " One Liners " + "-" * 35
        print "Quick Reference:"
        output_tools(self.reference, spacing=3, mode=OutputAlignment.LEFT)
        print
 
        print "Git Tagging:"
        output_tools(self.tagging, spacing=3, mode=OutputAlignment.LEFT)
        print

        print "Investigative Work:"
        output_tools(self.analysis, spacing=3, mode=OutputAlignment.LEFT) 
        print

        print "-" * 35 + " Whoops... " + "-" * 35
        print "Undo git fetch:"
        print "   git remote remove A"
        print "   git remote add A <path/to/repo>"
        print
        print "Delete git tag:"
        print "   git tag -d <tag_name>"
        print "   git push origin :refs/tags/<tag_name>"
        print
