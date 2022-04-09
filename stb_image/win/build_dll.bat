@echo off

call vcvars64
if not exist dll mkdir dll
pushd dll
call cl /LD ../../source/stb_image.c /link /DLL /OUT:stb_image.dll
del stb_image.obj
popd dll
