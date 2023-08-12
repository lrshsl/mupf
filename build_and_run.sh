#!/bin/sh

if [[ $0 = "dbg" ]]; then
   make dbg
   ./mupf $@
else
   make
   ./mupf $@
fi
