@echo off

call vcvars64
if not exist lib mkdir lib
pushd lib
call cl /c ../../source/stb_image.c
call cl /c ../../source/stb_image_write.c
call lib stb_image.obj /OUT:stb_image.lib
call lib stb_image_write.obj /OUT:stb_image_write.lib
del stb_image.obj
del stb_image_write.obj
popd lib
