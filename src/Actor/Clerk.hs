{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric      #-}
{-# LANGUAGE RecordWildCards    #-}

module Actor.Clerk
    ( OrderId , Price, Quantity
    , ClerkId (..)

    , postAsk
    , postBid
    , cancelAsk
    , cancelBid
    ) where

import           Control.Distributed.Process                         hiding
                                                                      (call)
import           Control.Distributed.Process.Platform.ManagedProcess
import           Data.Binary
import           Data.Typeable
import           Data.UUID
import           GHC.Generics
import           GHC.Int

type OrderId  = UUID
type Price    = Int64
type Quantity = Int32

newtype ClerkId = ClerkId { unClerkId :: ProcessId }

data PostAsk = PostAsk Price Quantity deriving (Typeable, Generic)
instance Binary PostAsk

data PostBid = PostBid Price Quantity deriving (Typeable, Generic)
instance Binary PostBid

data CancelAsk = CancelAsk OrderId deriving (Typeable, Generic)
instance Binary CancelAsk

data CancelBid = CancelBid OrderId deriving (Typeable, Generic)
instance Binary CancelBid

----

postAsk :: ClerkId -> Price -> Quantity -> Process OrderId
postAsk ClerkId{..} p q = call unClerkId $ PostAsk p q

postBid :: ClerkId -> Price -> Quantity -> Process OrderId
postBid ClerkId{..} p q = call unClerkId $ PostBid p q

cancelAsk :: ClerkId -> OrderId -> Process ()
cancelAsk ClerkId{..} o = call unClerkId $ CancelAsk o

cancelBid :: ClerkId -> OrderId -> Process ()
cancelBid ClerkId{..} o = call unClerkId $ CancelBid o

----

