{-# LANGUAGE OverloadedStrings #-}

module ConfigData where

import qualified Data.Map as M
import Data.Aeson

data Config = Config {
  remoteDirectory              :: String,
  remoteDirectoryContainerView :: Maybe String,
  image                        :: String,
  reads                        :: [ String ],
  writes                       :: [ String ],
  runCommand                   :: String,
  env                          :: M.Map String String
} deriving (Show)

instance FromJSON Config where
  parseJSON (Object v) =
    Config <$> v .: "remote_directory"
           <*> v .:? "remote_directory_container_view"
           <*> v .: "image"
           <*> v .: "reads"
           <*> v .: "writes"
           <*> v .: "run_command"
           <*> v .: "env"




