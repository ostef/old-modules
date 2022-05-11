@echo off

jai -no_dce -import_dir ../.. -import_dir c:/jai/modules main.jai -- %*
