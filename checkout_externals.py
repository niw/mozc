import sys
import os
import shutil

vars = {}
deps = {}
deps_os = {}

def Var(name):
    return vars[name]

def checkout(dir, url):
    shutil.rmtree(dir, True)
    os.system("svn co %s %s" % (url, dir))

def main():
    execfile('src/DEPS', globals(), globals())

    plat = sys.argv[1]
    for dir, url in deps.iteritems():
        checkout(dir, url)
    for dir, url in deps_os[plat].iteritems():
        checkout(dir, url)

if __name__ == '__main__':
    main()
