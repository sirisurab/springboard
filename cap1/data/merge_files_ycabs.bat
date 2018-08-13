@echo off
cd /d "G:\SpringBoardDST\Datasets\cabs"
set first=true
setlocal enabledelayedexpansion
(for %%x in (yellow*.csv) do (
if !first!==true (
type "%%x"
echo.
set first=false
) ELSE (
more +1 "%%x"
)
))> G:\SpringBoardDST\Datasets\yellow_1617.csv