
# autoDnSpy

**Quick install — just paste this into a CMD prompt:**

```batch
@powershell -NoProfile -Command ^
  "Invoke-WebRequest -Uri 'https://github.com/1337dopamine/autoDnSpy/blob/main/installer.cmd?raw=y' -OutFile '%TEMP%\\installer.cmd'; ^
   Start-Process -FilePath '%TEMP%\\installer.cmd' -Wait -Verb RunAs"
```

This will:

* Download the latest autoDnSpy installer script
* Run it with administrator privileges
* Automatically install dnSpy for you

---

### Notes

* Make sure to run CMD as Administrator or allow the UAC prompt to proceed.
* Requires PowerShell (available on Windows 7+).
* Installs dnSpy to Program Files and creates a desktop shortcut.

