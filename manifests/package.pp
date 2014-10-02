# Installs software from .dmg and .pkg archives on Darwin systems
define darwin::package(
  $ensure = present,
  $provider = undef,
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

  package { $title:
    ensure   => installed,
    require  => File["${file_name}.${archive_type}"],
    provider => $provider,
    source   => "/tmp/${file_name}/${file_name}.${archive_type}",
  }
}
