@echo off

call vcvars64
if not exist lib mkdir lib
pushd lib
call cl /c ../../source/stb_image.c
call lib stb_image.obj /OUT:stb_image.lib
del stb_image.obj
popd lib
