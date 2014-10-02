# == define: ca_certificate
#
# This resource downloads a specified certificate and stores into the systems keychain.
#
# !! Attention: Requires wget to be installed on the system !!
#
# === Variables
#
# [source]
#   The URI to the certificate.
# 
# [certificate_name]
#   The name under wich the certificate will be stored in the sstem keychain.
# 
# [verify_https_cert]
#   Verify ssl certificates when fetching the certificate. Defaults to 'false'.
# 
# === Examples
#
#  class { darwin::ca_certificate:
#    source            => 'https://www.mycompany.com/ca/certificates/certificate.crt'
#    certificate_name  => 'My Certificate'
#    verify_https_cert => true,
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
define darwin::ca_certificate (
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
