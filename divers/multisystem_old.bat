@echo Off
::http://fr.wikipedia.org/wiki/Variable_d%27environnement
::http://www.microsoft.com/resources/documentation/windows/xp/all/proddocs/en-us/runas.mspx?mfr=true
::Lancer MultiSystem dans VBox
::wmic diskdrive list full
::VBoxManage list -l usbhost
::wmic logicaldisk list full
::wmic logicaldisk list brief
::VERSION=1.0

::set SerialNumber=07A80C01655B0EAB
set SerialNumber=XXXXXXXXXXXXXXXX
set VAR=
set PhysicalDrive=wmic diskdrive get DeviceID,PNPDeviceID
SET CHEMIN=%ALLUSERSPROFILE%\multisystem.vmdk
SET PROGRAMME=%ProgramFiles%\Oracle\VirtualBox\VBoxManage.exe

::Test... sous vista et seven fo etre Administrateur
::cd "%ProgramFiles%"\oracle\virtualbox
::VBoxManage internalcommands createrawvmdk -filename %USERPROFILE%\.VirtualBox\multisystem.vmdk -rawdisk \\.\PhysicalDrive1
::VBoxManage internalcommands createrawvmdk -filename %USERPROFILE%\.Virtualbox\VDI\multisystem.vmdk -rawdisk \\.\PhysicalDrive1

::Détecter PhysicalDrive en cherchant N° de serie de la cle USB.
for /F "usebackq tokens=1" %%I in (`"%PhysicalDrive%" ^| findstr %SerialNumber%`) do set VAR=%%I
if "%VAR%" == "" goto PhysicalDriveNotFound

::Reading drive letter ...
for %%d in ( D E F G H I J K L M N O P Q R S T U V W X Y Z ) do if exist %%d:\boot\splash\splash-prevue.png set DISK=%%d
if %DISK% == none goto DiskNotFoundstart

::Calculating optimal ram use...
for /F "delims=" %%d in ('mem ^| find "XMS"') do set FREEMEM=%%d
if "%FREEMEM%" NEQ "" SET FREEMEM=%FREEMEM:~1,10%
if "%FREEMEM%" NEQ "" SET /A FREEMEM=%FREEMEM% / 2048
if "%FREEMEM%" LSS "256" SET FREEMEM=256
echo DISK %DISK% FREEMEM %FREEMEM% "%CHEMIN%"
if not exist "%PROGRAMME%" goto ProgNotFound

::Arrêter VBox
"%PROGRAMME%" controlvm "MSvirtual" poweroff >NUL

::Détacher disque associé vmdk
"%PROGRAMME%" modifyvm "MSvirtual" --hda none
"%PROGRAMME%" closemedium disk "%CHEMIN%"

::Supprimer disque associé vmdk
if exist "%CHEMIN%" DEL "%CHEMIN%"

::supprimer vm
"%PROGRAMME%" unregistervm "MSvirtual" --delete

::Créer vmdk
"%PROGRAMME%" internalcommands createrawvmdk -filename "%CHEMIN%" -rawdisk "%VAR%"

::creer vm
"%PROGRAMME%" createvm --name "MSvirtual" --register
"%PROGRAMME%" modifyvm "MSvirtual" --memory %FREEMEM% --vram 128 --acpi on --nic1 nat --ioapic on
"%PROGRAMME%" storagectl "MSvirtual" --name "IDE Controller" --add ide >NUL
"%PROGRAMME%" modifyvm "MSvirtual" --hda "%CHEMIN%"
"%PROGRAMME%" modifyvm "MSvirtual" --ostype "Linux26"
"%PROGRAMME%" modifyvm "MSvirtual" --audio dsound --audiocontroller ac97
"%PROGRAMME%" modifyvm "MSvirtual" --accelerate3d on
"%PROGRAMME%" modifyvm "MSvirtual" --pae on
"%PROGRAMME%" modifyvm "MSvirtual" --usb on
"%PROGRAMME%" modifyvm "MSvirtual" --usbehci on

::Demarrer VBox
"%PROGRAMME%" startvm "MSvirtual" --type gui

goto exit
:DiskNotFoundstart
echo error disk not found 

goto exit
:ProgNotFound
echo error "%PROGRAMME%" not exist

goto exit
:PhysicalDriveNotFound
echo error detect PhysicalDrive %SerialNumber%

:exit
