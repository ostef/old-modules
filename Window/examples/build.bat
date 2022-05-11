@echo off

jai -no_dce -meta Meta/Build -import_dir ../.. -import_dir c:/jai/modules custom_caption.jai -- %*
