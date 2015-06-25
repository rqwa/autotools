#! /bin/sh
# Copyright (C) 2011-2012 Free Software Foundation, Inc.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Test the '--basedir' option of the 'py-compile' script,

required=python
. ./defs || exit 1

# We'll need to create files in '..', so we need one more subdirectory
# level in order not to clutter up the top-level tests directory.
mkdir sandbox
cd sandbox

cp "$am_scriptdir/py-compile" . \
  || fatal_ "failed to fetch auxiliary script py-compile"

f=__init__
for d in foo foo/bar "$(pwd)/foo" . .. ../foo ''; do
  if test -z "$d"; then
    d2=.
  else
    d2=$d
  fi
  ../install-sh -d "$d2" "$d2/sub" || exit 99
  : > "$d2/$f.py"
  : > "$d2/sub/$f.py"
  ./py-compile --basedir "$d" "$f.py" "sub/$f.py"
  ls -l "$d2" "$d2/sub" # For debugging.
  test -f "$d2/$f.pyc"
  test -f "$d2/$f.pyo"
  test -f "$d2/sub/$f.pyc"
  test -f "$d2/sub/$f.pyo"
  rm -f "$d2/$f.pyc" "$d2/$f.pyo" "$d2/sub/$f.pyc" "$d2/sub/$f.pyo"
  find . | grep '\.py[co]$' && exit 1
done

:
