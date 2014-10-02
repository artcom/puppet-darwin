class darwin::ios (
  $install_simulators = false,
) {

  require darwin::xcode

  if ($install_simulators) {
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

}