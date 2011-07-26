Mozc
====

[Mozc](http://code.google.com/p/mozc/) is an open source Japanese input method for Chromium OS, Mac and Linux developed by Google, Inc.
Their [Google日本語入力](http://www.google.com/intl/ja/ime/index-mac.html) is an original product of Mozc which suports Windows as well.

Unfortunately, Mozc is an open source under [New BSD License](http://www.opensource.org/licenses/bsd-license.php) but [they can't commit any patches written by non-Google employee, so far](https://twitter.com/taku910/status/95089697172357120), which is not like the relationship between Chrome and Chromium.

Scinse this limitation of Mozc project, I checked out the code from the original SVN repository then mirror it to this Git repository to commit my patches.
I'll keep sync this repo to original SVN repository but this synchronization is done by hand so you may prefer to use original reposiroty then fetch my patches from here.

Also, I've filed these paches to [the original issue tracking list](http://code.google.com/p/mozc/issues/list) so that they can, in future, merge them into the orignal repository.

Extra steps to the original Build Instructions
----------------------------------------------

 1. Checkout source code from this repository using `git` command.
 1. run `checkout_externals.sh` instead of runing gclient command described in [the original instructions](http://code.google.com/p/mozc/wiki/MacBuildInstructions).
 1. Follow instructions.
