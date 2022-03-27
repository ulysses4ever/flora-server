module SpecHelpers where

import Control.Monad
import Data.Pool
import Database.PostgreSQL.Entity.DBT
import Database.PostgreSQL.Simple (Connection, close)
import Database.PostgreSQL.Simple.Migration
import Flora.Import.Categories (importCategories)
import Flora.Model.User
import Flora.Model.User.Update (insertUser)
import Flora.UserFixtures

migrate :: Connection -> IO ()
migrate conn = do
  void $ runMigrations conn defaultOptions [MigrationInitialization, MigrationDirectory "./migrations"]
  pool <- createPool (pure conn) close 1 10 1
  withPool pool $ do
    void importCategories
    insertUser hackageUser