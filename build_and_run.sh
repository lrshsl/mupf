#!/bin/sh

if [[ $0 = "dbg" ]]; then
   make dbg
   ./mupf $@:1    # Slices from 1 to end
else
   make
   ./mupf $@
fi
