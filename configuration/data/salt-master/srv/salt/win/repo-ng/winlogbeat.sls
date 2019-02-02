winlogbeat:
  '6.60':
    installer: salt://win/repo-ng/installers/<installer_executable>.exe
    full_name: 'Elastic Winlogbeat'
    reboot: False
    install_flags: '/S'
    uninstaller: '%ProgramFiles%/<directories>/uninstall.exe'
    uninstall_flags: '/S'
