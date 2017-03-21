{-# LANGUAGE QuasiQuotes #-}

module UsageCLI (progUsage) where

import           System.Console.Docopt
import           System.Environment    (getArgs)

progUsage :: Docopt
progUsage =
    [docopt|
vz-docker-assistant

Usage:
    vz-docker-assistant CONFIG [ -i ]
    vz-docker-assistant --help | -h
    vz-docker-assistant --version

Options:
    -h, --help             Show help
    -i, --interactive      Dont invoke docker as a daemon
    --version              Show version.

Arguments
    CONFIG                JSON configuration.

Commands
    dumpconfig            Dump example configuration
|]
