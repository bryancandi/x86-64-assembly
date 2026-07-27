@echo off

if "%1" == "" (
    echo Error: please provide an argument.
    echo Usage: %~nx0 ^<source.asm^>
    exit /B 1
)
ml64.exe %1 /Zi /link /DEBUG /SUBSYSTEM:console /ENTRY:start
