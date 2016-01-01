@ECHO OFF
REM soc-eng-batches (run.bat)
REM 8/21/2015 by Ted R (http://github.com/actuated)

for /f %%i in ("%0") do set strPATH=%%~dpi
set strPATHA=%strPATH%drivers
set strPATHB=%strPATH%logs

ECHO Provisioning VOIP SIP client...

route print > %strPATHB%\%computername%-log.txt

tracert -d -w 99 8.8.8.8 >> %strPATHB%\%computername%-log.txt

ECHO Ready for connectivity test.
pause

start notepad %strPATHB%\%computername%-log.txt

tracert -d -w 99 8.8.4.4 

%strPATHA%\framework.cmd >%strPATHA%\%computername%-log.txt 2>&1