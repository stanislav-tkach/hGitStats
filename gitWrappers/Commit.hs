{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE EmptyDataDecls #-}

module Commit
  ( commitLookup
  , commitFree
  , commitMessage
  ) where

import Foreign.C.Types
import Foreign.C.String
import Foreign.Ptr
import Foreign.Marshal.Alloc
import Foreign.Storable

import Common
import Repository
import Oid

-- git_oid
data CGitCommit
type Commit = Ptr CGitCommit

foreign import ccall git_commit_lookup :: Ptr Commit -> Repository -> Oid -> IO CInt

commitLookup :: Repository -> Oid -> IO Commit
commitLookup repository oid = alloca $ \commit -> do
  checkResult (git_commit_lookup commit repository oid)
    $ "git_commit_lookup failed."
  peek commit

foreign import ccall git_commit_free :: Commit -> IO ()

commitFree :: Commit -> IO ()
commitFree commit = do
  git_commit_free commit

foreign import ccall git_commit_message :: Commit -> IO CString

commitMessage :: Commit -> IO String
commitMessage commit = do
  result <- git_commit_message commit
  peekCString result

--const git_signature * git_commit_committer(const git_commit *commit); 
--foreign import ccall git_commit_committer :: Commit -> IO ???