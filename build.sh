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
tools/run-tests.py --outdir out.gn/release > tests.out 2> tests.err && true

popd # v8

# copy files
mkdir -p v8-prebuilt/{include,lib}
cp v8/include/*.h v8-prebuilt/include/
cp v8/out.gn/release/obj/libv8_lib* v8-prebuilt/lib/
