# == Define: bacula::director::custom_config
#
# Include a custom configuration file in <tt>/etc/bacula/bacula-dir.d</tt>.
#
# === Parameters
#
# [*ensure*]
#   Ensure the file is present or absent.  The only valid values are <tt>file</tt> or
#   <tt>absent</tt>. Defaults to <tt>file</tt>.
# [*director_server*]
#   WHere this config will be deployed, if using stored configs.
# [*content*]
#   String containing the content for the configuration file.  Usually supplied
#   with a template.
# [*source*]
#   The source location of the configuration file to deploy in <tt>bacula-dir.d</tt>.
#
# === Examples
#
# Provide some examples on how to use this type:
#
#   bacula::director::custom_config { 'namevar' :
#     ensure => file,
#     source => 'puppet:///modules/my_bacula/custom.conf'
#   }

define bacula::director::custom_config (
  String $ensure = 'file',
  String $director_server = $facts['fqdn'],
  Optional[String] $content  = undef,
  Optional[String] $source   = undef
  ) {

  include 'bacula::director'

  if $content and $source {
    fail('You may not supply both content and source parameters')
  } elsif $content == undef and $source == undef {
    fail('You must supply either the content or source parameter')
  }

  file { "/etc/bacula/bacula-dir.d/custom-${name}.conf":
    ensure  => file,
    owner   => 'bacula',
    group   => 'bacula',
    mode    => '0640',
    content => $content,
    source  => $source,
    require => File['/etc/bacula/bacula-dir.conf'],
    before  => Service['bacula-dir'],
    notify  => Exec['bconsole reload'],
  }
}
