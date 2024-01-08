:: Build on Windows
:: === Setup ===
@echo off
setlocal
pushd %~dp0app

:: === Processing ===
set PYTHONUTF8=1
flet build --project flet-apk --product flet-apk apk

:: === Post-processing ===
popd