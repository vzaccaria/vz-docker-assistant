{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE OverloadedStrings #-}

module PrintCommands where

import Prelude (concatMap,Maybe(..),(<$>),putStrLn, ($), (++), (==), Bool(..), (||), any, all, elem, not, error)
import Data.Monoid (Any, All)
import ReadConfig (readConfig, parseCommand, Config(..))
import qualified ReadConfig as C
import Data.String.Interpolate

remoteCopyTo url (Just port) rd f = [i|scp -P #{port} ./#{f} #{url}:#{rd}
|]
remoteCopyTo url Nothing rd f =     [i|scp ./#{f} #{url}:#{rd}
|]

remoteCopyFrom url (Just port) rd f = [i|scp -P #{port} #{url}:#{rd}/#{f} ./#{f}
|]
remoteCopyFrom url Nothing rd f =     [i|scp #{url}:#{rd}/#{f} ./#{f}
|]

getCommandLog config isDaemon=
  let
      cd = case remoteDirectoryContainerView config of
            (Just d) -> d
            _ -> "/data"

      rd = remoteDirectory config

      u = url config
      p = port config 
      copyTo = concatMap (remoteCopyTo u p rd) (reads config)
      copyFrom = concatMap (remoteCopyFrom u p rd) (writes config)
      cmd = parseCommand config
      daemon = if isDaemon then "-d" else ""

      command = [i|docker run #{daemon} -w #{cd} -v #{rd}:#{cd} #{image config} #{cmd}
|]
  in
    copyTo ++ command ++ copyFrom

checkFile f = elem '/' f
checkConfig c = not $ any (checkFile) (reads c) || any (checkFile) (writes c)

printCommandLog fn isInteractive = do {
  c <- readConfig fn;
  case checkConfig c of
    False -> error "Sorry, files should only be local!"
    _ -> putStrLn $ getCommandLog c (not isInteractive);
}



