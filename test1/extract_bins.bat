@echo off
SET SEVENZIP="C:\Program Files\7-Zip\7z.exe"
IF NOT EXIST %SEVENZIP% (echo 7-zip not found! && exit)
IF NOT EXIST SimxBin.7z IF NOT EXIST Havok.7z (echo Nothing to extract! SimxBin.7z or Havok.7z required. && exit)


SET EXTRACTED=
IF EXIST SimxBin.7z call :SimxBin
IF EXIST Havok.7z call :Havok
IF [EXTRACTED]==[] (echo No archive found to extract! && exit)
echo Extracted: %EXTRACTED%
goto :end

:SimxBin
echo FakeCgfxDD...
TASKKILL /F /IM FakeCgfxDD.exe
rmdir FakeCgfxDD /S /Q
mkdir FakeCgfxDD
pushd FakeCgfxDD
%SEVENZIP% x ..\SimxBin.7z
popd
SET EXTRACTED=%EXTRACTED%FakeCgfxDD;

echo SimHost...
TASKKILL /F /IM SimHost.exe
rmdir SimHost /S /Q
mkdir SimHost
pushd SimHost
%SEVENZIP% x ..\SimxBin.7z
SET EXTRACTED=%EXTRACTED%SimHost;
popd

echo SimIG...
TASKKILL /F /IM SimIG.exe
rmdir SimIG /S /Q
mkdir SimIG
pushd SimIG
%SEVENZIP% x ..\SimxBin.7z
%SEVENZIP% x ..\Shaders.7z
SET EXTRACTED=%EXTRACTED%SimIG;
popd

goto :end

:Havok
echo Havok...
rmdir Havok.SimIG /S /Q
mkdir Havok.SimIG
pushd Havok.SimIG
%SEVENZIP% x ..\Havok.7z
SET EXTRACTED=%EXTRACTED%Havok;
popd
goto :end

:end