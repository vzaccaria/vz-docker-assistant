{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE OverloadedStrings #-}

module PrintCommands where

import Prelude (concatMap,Maybe(..),(<$>),putStrLn, ($), (++))
import ReadConfig (readConfig, parseCommand, Config(..))
import qualified ReadConfig as C
import Data.String.Interpolate

remoteCopyTo url (Just port) rd f = [i|scp ./#{f} #{url}:#{rd} -p #{port}
|]
remoteCopyTo url Nothing rd f = [i|scp ./#{f} #{url}:#{rd}
|]

remoteCopyFrom url (Just port) rd f = [i|scp #{url}:#{rd} -p #{port} ./#{f}
|]
remoteCopyFrom url Nothing rd f = [i| scp #{url}:#{rd} ./#{f}
|]

getCommandLog config =
  let
      cd = case remoteDirectoryContainerView config of
            (Just d) -> d
            _ -> "/"

      rd = remoteDirectory config

      u = url config
      p = port config 
      copyTo = concatMap (remoteCopyTo u p rd) (reads config)
      copyFrom = concatMap (remoteCopyFrom u p rd) (writes config)
      cmd = parseCommand config

      command = [i|docker run -d -w #{cd} -v #{rd}:#{cd} #{image config} #{cmd}
|]
  in
    copyTo ++ command ++ copyFrom

printCommandLog fn = do {
  c <- readConfig fn;
  putStrLn $ getCommandLog c;
}



