@echo off

call vcvars64
if not exist dll mkdir dll
pushd dll
call cl /LD ../../source/stb_image.c /link /DLL /OUT:stb_image.dll
call cl /LD ../../source/stb_image_write.c /link /DLL /OUT:stb_image_write.dll
del stb_image.obj
del stb_image_write.obj
popd dll
