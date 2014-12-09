# == Class: xcode
#
# This class installs DMG and PKG packages on the system.
#
# === Variables
#
# [ensure]
#   Defaults to 'present'.
# 
# [provider]
#   Either 'appdmg' or 'pkgdmg'. Defaults to 'appdmg'.
# 
# [source_dir]
#   Path to the DMG or PKG.
# 
# [archive_type]
#   Either 'dmg' or 'pkg'. Defaults to 'dmg'.
#
# === Examples
#
#  darwin::package { 'myPackage':
#    ensure       => installed,
#    provider     => pkgdmg,
#    source_dir   => puppet://files/myInstaller.dmg,
#    archive_type => 'pkg',
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
define darwin::package(
  $ensure = present,
  $provider = appdmg,
  $source_dir = undef,
  $archive_type = 'dmg',
) {

  $file_name = darwin_basename($source_dir, ".${archive_type}")

  file {
    "/tmp/${file_name}":
      ensure => directory;

    "${file_name}.${archive_type}":
      ensure => file,
      source => $source_dir,
      path   => "/tmp/${file_name}/${file_name}.${archive_type}";
  }

  package { $file_name:
    ensure   => installed,
    require  => File["${file_name}.${archive_type}"],
    provider => $provider,
    source   => "/tmp/${file_name}/${file_name}.${archive_type}",
  }
}
