# == Class: ios
#
# This class installs the iOS Simulators included in the currently installed Xcode IDE on the system.
#
# === Examples
#
#  class { 'darwin::ios': }
#
# === Authors
#
# ART+COM AG <info@artcom.de>
#
# === Copyright
#
# Copyright 2014 ART+COM AG, unless otherwise noted.
#
class darwin::ios {

  require darwin::xcode

  darwin::package { 'MobileDevice':
    ensure       => installed,
    provider     => pkgdmg,
    source_dir   => '/Applications/Xcode.app/Contents/Resources/Packages/MobileDevice.pkg',
    archive_type => 'pkg',
  }

  darwin::package { 'MobileDeviceDevelopment':
    ensure        => installed,
    provider      => pkgdmg,
    source_dir    => '/Applications/Xcode.app/Contents/Resources/Packages/MobileDeviceDevelopment.pkg',
    archive_type  => 'pkg',
  }
}