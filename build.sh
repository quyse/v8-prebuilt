#!/bin/bash

# enter python2 virtual environment (if it works)
virtualenv2 venv && source venv/bin/activate

set -e

# clone depot tools
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git depot_tools
export PATH="$PWD/depot_tools:$PATH"

# fetch code
gclient sync --no-history --with_tags -r v8@5.8.283.36

# enter v8 directory
pushd v8

# configure
gn gen out.gn/release --fail-on-unused-args --args='is_debug=false v8_enable_i18n_support=false'

# build
ninja -C out.gn/release

# run tests
tools/run-tests.py --outdir out.gn/release

popd # v8
