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

class FileImpl(object):
  def __init__(self, file_location):
    self.file_location = file_location

  def __str__(self):
    return self.file_location

  def GetPath(self):
    return os.path.split(self.file_location)[0]

  def GetFilename(self):
      rev_tokens = self.file_location.split('@')
      return os.path.split(rev_tokens[0])[1]

def File(file_location):
  return FileImpl(file_location)

def checkout(dir, item, force=False):
  if force:
    shutil.rmtree(dir, True)
  if isinstance(item, FileImpl):
    os.system("svn checkout --trust-server-cert --non-interactive --depth empty %s %s" % (item.GetPath(), dir))
    os.system("svn update --trust-server-cert --non-interactive %s" % os.path.join(dir, item.GetFilename()))
  else:
    os.system("svn checkout --trust-server-cert --non-interactive %s %s" % (item, dir))

def parse_args():
  parser = optparse.OptionParser(usage="%prog [options] {" + ", ".join(deps_os.keys()) + "}")
  parser.add_option("-f", "--force", help="force update externals",
                    action="store_true", dest="force", default=False)
  return parser.parse_args()

def main():
  execfile(os.path.join(os.path.dirname(__file__), "src", "DEPS"), globals(), globals())

  (options, args) = parse_args()

  if len(args) > 0 and deps_os.has_key(args[0]):
    for dir, item in deps.iteritems():
      checkout(dir, item, options.force)
    for dir, item in deps_os[args[0]].iteritems():
      checkout(dir, item, options.force)
  else:
    print >> sys.stderr, "unknown or missing platform."
    exit(1)

if __name__ == '__main__':
  main()
