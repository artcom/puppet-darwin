class darwin::xcode (
  $last_license_agreed_to = 'EA1057',
  $ide_version            = undef,
  $ide_dmg                = undef,
  $cl_tools_dmg           = undef,
) {

  darwin::package { 'xcode_ide':
    ensure      => installed,
    provider    => appdmg,
    source_dir  => $ide_dmg,
  }

  darwin::package { 'xcode_cl_tools':
    ensure      => installed,
    provider    => pkgdmg,
    source_dir  => $cl_tools_dmg,
  }

  exec { 'accept_xcode_licence':
    require     => Package['xcode_ide'],
    command     => ["defaults write /Library/Preferences/com.apple.dt.Xcode.plist IDELastGMLicenseAgreedTo ${last_license_agreed_to} && defaults write /Library/Preferences/com.apple.dt.Xcode.plist IDEXcodeVersionForAgreedToGMLicense ${ide_version}"],
    path        => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    subscribe   => Package['xcode_ide'],
    refreshonly => true,
  }

}