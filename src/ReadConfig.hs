{-# LANGUAGE OverloadedStrings #-}

module ReadConfig where

import Data.Either ()
import Data.List.Split (splitOn)
import Data.List (intercalate)
import qualified Data.ByteString.Lazy as B
import qualified Prelude as P
import Prelude (String, IO, Either(..), Integer, return, ($), error, (<$>), (!!), map, (-),Show, Maybe, (<*>))

import Text.Parsec 
import Text.Parsec.Prim
import Text.Parsec.Combinator
import Text.ParserCombinators.Parsec.Number


import qualified Data.Map as M
import Data.Aeson

data Config = Config {
  remoteDirectory              :: String,
  remoteDirectoryContainerView :: Maybe String,
  image                        :: String,
  reads                        :: [ String ],
  writes                       :: [ String ],
  runCommand                   :: String,
  url                          :: String,
  port                         :: Maybe String,
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
           <*> v .: "url"
           <*> v .:? "port"
           <*> v .: "env"

readConfig :: String -> IO Config
readConfig n = do
    d <- eitherDecode <$> B.readFile n
    case d of
      Left e -> error e
      Right ps -> return ps

data Type = Input | Output | None

idParser = do
  x <- (char '$') <|> (char '@')
  e <- int
  case x of
     '$' -> return $ (Input, e)
     '@' -> return $ (Output,e)

parsePlaceHolder :: Config -> [P.Char] -> [P.Char]
parsePlaceHolder c s =
  case (parse idParser "" s) of
    Left _ -> s
    Right (t, n) ->
      case t of
        Input -> (reads c) !! (n - 1)
        Output -> (writes c ) !! (n - 1)

parseCommand :: Config -> String
parseCommand c =
    let cm = runCommand c
        tok = splitOn " " cm
    in
      P.unwords $ map (parsePlaceHolder c) tok

