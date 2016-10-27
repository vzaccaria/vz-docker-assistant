{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Main where

import Prelude (($), Maybe(..), Bool(..), not, return, putStrLn, map, IO (..), readFile, (=<<))
import System.Environment (getArgs)
import System.Console.Docopt.NoTH
import System.Process
import Data.String
import System.Exit
import qualified Data.Map as M
import Control.Monad (when)
import UsageCLI (progUsage)
import qualified Data.Text as T
import Debug.Trace
import Filesystem.Path.CurrentOS (filename, encodeString, replaceExtension)

import PrintCommands

split :: String -> String -> [String]
split sep str = map T.unpack $ T.splitOn (T.pack sep) (T.pack str)

dispatchOptions :: Docopt -> IO ()
dispatchOptions usage = do {
  opts <- parseArgsOrExit usage =<< getArgs;
  file <- getArgOrExitWith usage opts (argument "CONFIG");
  let
      -- hasLOpt       name = (isPresent opts (longOption name))
      -- getLOptVal    name = let (Just s) = getArg opts (longOption name) in s

      -- justLatex = isPresent opts (longOption "latex")

      -- fname = filename $ fromString file
      -- oname = encodeString $ replaceExtension fname (T.pack "pdf") 

  in do {
    printCommandLog file;
  };
  return ();
}


main :: IO ()
main = dispatchOptions progUsage
