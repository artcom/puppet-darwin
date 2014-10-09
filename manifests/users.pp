# == Class: users
#
# This class configures user accounts.
#
# === Variables
#
# [user_name]
#   The name of the user to configure.
#
# [user_group]
#   The name of the group the user resides in.
#
# [user_home]
#   The home directory of the user.
#
# [disable_icloud_signin_popup]
#   Deactivates the iCloud sign-in pop-up for a given user. Defaults to 'false'. 
#
# === Examples
#
#  class { 'darwin::users':
#    user_name => 'john-doe',
#    user_group => 'staff',
#    user_home => '/Users/john-doe'
#    disable_icloud_signin_popup => true,
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
class darwin::users (
  $user_name = undef,
  $user_group = undef,
  $user_home = undef,
  $disable_icloud_signin_popup = false,
) {

  if $disable_icloud_signin_popup {
    file { "${user_home}/Library":
      ensure => directory,
      mode   => '0644',
      owner  => $user_name,
      group  => $user_group,
      before => File["${user_home}/Library/Preferences"],
    }

    file { "${user_home}/Library/Preferences":
      ensure => directory,
      mode   => '0644',
      owner  => $user_name,
      group  => $user_group,
      before => File["${user_home}/Library/Preferences/com.apple.SetupAssistant.plist"],
    }

    file { "${user_home}/Library/Preferences/com.apple.SetupAssistant.plist":
      ensure => file,
      owner  => $user_name,
      group  => $user_group,
      before => Exec['disable_icloud_signin_popup'],
    }

    exec { 'disable_icloud_signin_popup':
      command => "defaults write ${user_home}/Library/Preferences/com.apple.SetupAssistant DidSeeCloudSetup -bool TRUE && defaults write ${user_home}/Library/Preferences/com.apple.SetupAssistant LastSeenCloudProductVersion '1.9'",
      path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
      unless  => "defaults read ${user_home}/Library/Preferences/com.apple.SetupAssistant DidSeeCloudSetup",
      require => File["${user_home}/Library/Preferences/com.apple.SetupAssistant.plist"],
    }
  }
}