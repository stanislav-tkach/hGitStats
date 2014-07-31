module Main where

import System.Environment (getArgs)

import Repository
import Oid
import Revwalk
import Commit

parseCommandLine :: IO String
parseCommandLine = do
  args <- getArgs
  case args of
    [] -> error "Specify path to repository."
    _ -> return . head $ args

-- TODO: FIXME:
-- bracket/finally/onException:

main :: IO ()
main = do
  path <- parseCommandLine
  repository <- repositoryOpen path
  headOid <- headId repository
  walker <- revwalkNew repository
  revwalkSorting walker Topological
  revwalkPush walker headOid
  -- 
  commit <- commitLookup repository headOid
  
  -- test
  message <- commitMessage commit
  print message

--  -- test 2
--  nextOid <- revwalkNext walker
--  nextCommit <- commitLookup repository nextOid
--  nextMessage <- commitMessage nextCommit
--  print nextMessage

--  -- test 3
--  nextOid2 <- revwalkNext walker
--  nextCommit2 <- commitLookup repository nextOid2
--  nextMessage2 <- commitMessage nextCommit2
--  print nextMessage2
  testVal <- revwalkNext walker
  print testVal
  




-- TODO: FIXME:
{-|
    git_revwalk_new(&walker, repo);
    git_revwalk_sorting(walker, GIT_SORT_TOPOLOGICAL);
    git_revwalk_push(walker, &oid);

    const char *commit_message;
    const git_signature *commit_author;

    while(git_revwalk_next(&oid, walker) == GIT_SUCCESS) {
        if(git_commit_lookup(&commit, repo, &oid)){
            fprintf(stderr, "Failed to lookup the next object\n");
            return 1;
        }

        commit_message  = git_commit_message(commit);
        commit_author = git_commit_committer(commit);

        // Don't print the \n in the commit_message 
        printf("'%.*s' by %s <%s>\n", strlen(commit_message)-1, commit_message, commit_author->name, commit_author->email);

        git_commit_free(commit);
    }

    git_revwalk_free(walker);
-}

  --
  commitFree commit
  --

  revwalkFree walker
  oidFree headOid
  repositoryFree repository
  return ()
