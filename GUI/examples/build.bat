@echo off

jai -no_dce -no_check main.jai -- %* --- import_dir ../.. import_dir c:/jai/modules/
