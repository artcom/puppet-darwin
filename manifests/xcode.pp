# == Class: xcode
#
# This class installs Xcode IDE and Xcode Commandline Tools on the system. Accepts EULA automatically.
#
# === Variables
#
# [last_license_agreed_to]
#   Code for the last license that has been accepted. Defaults to 'EA1057'.
# 
# [ide_version]
#   Code for the last IDE version that has been accepted.
# 
# [ide_dmg]
#   Path to the Xcode IDE installer DMG.
# 
# [cl_tools_dmg]
#   Path to the Xcode Command Line Tools installer DMG.
#
# === Examples
#
#  class { 'darwin::xcode':
#    last_license_agreed_to => 'EA1057',
#    ide_version            => '5.1.1',
#    ide_dmg                => 'puppet:///files/packages/xcode_5.1.1.dmg',
#    cl_tools_dmg           => 'puppet:///files/packages/command_line_tools_for_osx_10.9_september_2014.dmg',
#  }
#
# === Authors
#
# ART+COM AG <info@artcom.de>
#
# === Copyright
#
# Copyright 2014 ART+COM AG, unless otherwise noted.
#
class darwin::xcode (
  $last_license_agreed_to = 'EA1057',
  $ide_version            = undef,
  $ide_dmg                = undef,
  $cl_tools_dmg           = undef,
) {

  darwin::package { 'xcode_ide':
    ensure     => installed,
    provider   => appdmg,
    source_dir => $ide_dmg,
    notify     => Exec['accept_xcode_licence']
  }

  darwin::package { 'xcode_cl_tools':
    ensure     => installed,
    provider   => pkgdmg,
    source_dir => $cl_tools_dmg,
  }

  exec { 'accept_xcode_licence':
    command     => ["defaults write /Library/Preferences/com.apple.dt.Xcode.plist IDELastGMLicenseAgreedTo ${last_license_agreed_to} && defaults write /Library/Preferences/com.apple.dt.Xcode.plist IDEXcodeVersionForAgreedToGMLicense ${ide_version}"],
    path        => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    refreshonly => true,
  }

}