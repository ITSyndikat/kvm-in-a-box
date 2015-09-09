module Systemd (vmInitResource) where

import Data.List
import Data.Monoid
import System.FilePath
import System.Directory

import Resource
import Config
import Types

vmInitResource :: VmName -> [String] -> IO Resource
vmInitResource vmn (cmd:args) = do
  Just kibSupervise <- findExecutable "kib-supervise"
  Just cmd' <- findExecutable cmd
  return $ SimpleFileResource {
    rPath = etcdir </> "systemd/system/kib-" <> vmn <.> "service",
    rOwner = OwnerVm vmn,
    rNormalize = id,
    rContent = service vmn $ kibSupervise:("kib-"++vmn):cmd':args
 }

service vmn (cmd:args) = "\
 \[Unit]\n\
 \Description=Kvm-in-a-box VM: "++vmn++"\n\
 \After=kvm-in-a-box.target\n\
 \\n\
 \[Service]\n\
 \User=kib-"++vmn++"\n\
 \ExecStart="++cmd++" "++(intercalate " " $ map (("'"++) . (++"'")) args)++"\n\
 \Restart=on-abnormal\n\
 \\n\
 \[Install]\n\
 \WantedBy=WantedBy=multi-user.target\n"
