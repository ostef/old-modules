@echo off

jai -no_dce -import_dir ../.. -import_dir %JAI_PATH%/jai/modules main.jai -- %*
