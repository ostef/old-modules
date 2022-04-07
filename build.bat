@echo off

jai -meta Meta/Build -no_dce -import_dir . -import_dir c:/jai/modules/ tests.jai -- %*
