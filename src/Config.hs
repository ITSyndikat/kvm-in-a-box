{- LANGUAGE CPP -}
module Config where

import System.FilePath

configFile = etcdir </> "kvm-in-a-box.cfg"

stateFile = varlibdir </> "state"

rootRel root path = root </> makeRelative "/" path

varrundir = "/var/run/kib/"
varlibdir = "/var/lib/kib/"
etcdir = "/etc"
