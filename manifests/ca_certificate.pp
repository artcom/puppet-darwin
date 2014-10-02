define darwin::ca_certificate(
  $source = undef,
  $certificate_name = undef,
  $verify_https_cert = false,
) {
    # download certificate
    $verify_https = $verify_https_cert ? {
      true  => '',
      false => '--no-check-certificate',
    }
    $temp_path = "/tmp/${certificate_name}"
    exec { 'get_certificate':
      command => "wget ${verify_https} -O ${temp_path} ${source} 2> /dev/null",
      path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
      creates => $temp_path,
    }

    # store into keychain
    exec { 'install_certificate':
      command     => "security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ${temp_path}",
      path        => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
      require     => Exec['get_certificate'],
      refreshonly => true,
      subscribe   => Exec['get_certificate'],
    }
}
