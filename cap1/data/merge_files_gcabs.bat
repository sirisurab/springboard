@echo off
cd /d "G:\SpringBoardDST\Datasets\cabs"
set first=true
setlocal enabledelayedexpansion
(for %%x in (green*.csv) do (
if !first!==true (
type "%%x"
echo.
set first=false
) ELSE (
more +1 "%%x"
)
))> G:\SpringBoardDST\Datasets\green_1617.csv