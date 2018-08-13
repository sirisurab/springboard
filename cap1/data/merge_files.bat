@echo off
cd /d "G:\SpringBoardDST\Datasets\transit"
set first=true
setlocal enabledelayedexpansion
(for %%x in (*.txt) do (
if !first!==true (
type "%%x"
echo.
set first=false
) ELSE (
more +1 "%%x"
)
))> G:\SpringBoardDST\Datasets\turnstile_1617.txt