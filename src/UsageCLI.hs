{-# LANGUAGE QuasiQuotes #-}
module UsageCLI (progUsage) where

import System.Environment (getArgs)
import System.Console.Docopt

progUsage :: Docopt
progUsage = [docopt|
vz-docker-assistant

Usage:
    vz-docker-assistant CONFIG
    vz-docker-assistant --help | -h
    vz-docker-assistant --version

Options:
    -h, --help             Show help
    --version              Show version.

Arguments
    CONFIG                 JSON configuration.
|]
