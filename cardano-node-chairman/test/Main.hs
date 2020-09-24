
module Main
  ( main
  ) where

import           Control.Monad
import           Control.Monad.IO.Class
import           Control.Monad.Trans.Resource
import           Data.Function
import           Hedgehog
import           System.IO (IO)

import qualified Control.Concurrent as IO
import qualified Hedgehog as H
import qualified Hedgehog.Extras.Test.Base as H
import qualified System.IO as IO

main :: IO ()
main = do
  void . check $ H.propertyOnce . H.workspace "chairman" $ \_ -> do
    void . register . liftIO $ IO.appendFile "logs.txt" "Cleanup\n"

    void . liftResourceT . resourceForkIO $ do
      liftIO $ IO.appendFile "logs.txt" "Forked\n"
      void . forever . liftIO $ IO.threadDelay 100000000
      liftIO $ IO.appendFile "logs.txt" "Thread done\n"

      liftIO $ IO.appendFile "logs.txt" "Done\n"
      return ()

    H.success

  void . forever $ IO.threadDelay 100000000

  return ()
