# == Class: darwin
#
# This class configures computers running Darwin operating systems (i.e. OS X).
#
# This module supports setup of the following components:
#   - Xcode IDE                                (see darwin::xcode)
#   - Xcode command line tools                 (see darwin::xcode)
#   - Xcode license agreements (darwin::xcode) (see darwin::xcode)
#   - iOS Simulators                           (see darwin::ios)
#   - installation of dmg and pkg packages     (see darwin::package)
#   - installation of certificates             (see darwin::ca_certificate)
#
# === Variables
#
# [disable_icloud_signin_popup_globally]
#   Deactivate the icloud popup on first login for all newly created users. Defaults to 'false'.
#
# === Examples
#
#  class { 'darwin':
#    disable_icloud_signin_popup_globally => true,
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
class darwin (
  $disable_icloud_signin_popup_globally = false,
) {

  if ($disable_icloud_signin_popup_globally) {
    file { '/tmp/disable_icloud_signin_popup_global.sh':
      ensure => 'file',
      mode   => '0700',
      owner  => 'root',
      group  => 'wheel',
      source => 'puppet:///files/disable_icloud_signin_popup_global.sh',
    }
    exec { 'disable_icloud_signin_popup_globally':
      require => File['/tmp/disable_icloud_signin_popup_global.sh'],
      command => 'sh /tmp/disable_icloud_signin_popup_global.sh',
      path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    }
  }

}
