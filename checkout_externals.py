#!/usr/bin/python

import sys
import os
import shutil
import optparse

vars = {}
deps = {}
deps_os = {}

def Var(name):
  return vars[name]

def checkout(dir, url, force=False):
  if force:
    shutil.rmtree(dir, True)
  os.system("svn checkout --trust-server-cert --non-interactive %s %s" % (url, dir))

def parse_args():
  parser = optparse.OptionParser(usage="%prog [options] {" + ", ".join(deps_os.keys()) + "}")
  parser.add_option("-f", "--force", help="force update externals",
                    action="store_true", dest="force", default=False)
  return parser.parse_args()

def main():
  execfile(os.path.join(os.path.dirname(__file__), "src", "DEPS"), globals(), globals())

  (options, args) = parse_args()

  if len(args) > 0 and deps_os.has_key(args[0]):
    for dir, url in deps.iteritems():
      checkout(dir, url, options.force)
    for dir, url in deps_os[args[0]].iteritems():
      checkout(dir, url, options.force)
  else:
    print >> sys.stderr, "unknown or missing platform."
    exit(1)

if __name__ == '__main__':
  main()
