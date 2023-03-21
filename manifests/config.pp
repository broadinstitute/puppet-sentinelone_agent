#
# @summary Manage the SentinelOne Agent configuration
#
class sentinelone_agent::config {
  require logrotate

  # Token is just a base64-encoded string of JSON
  $token_pieces = parsejson(base64('decode', $sentinelone_agent::token))
  $site_key = $token_pieces['site_key']
  $url = $token_pieces['url']

  file { '/opt/sentinelone/configuration/basic.conf':
    ensure  => 'file',
    group   => 'sentinelone',
    mode    => '0600',
    owner   => 'sentinelone',
    require => $sentinelone_agent::install::pkg_req,
  }

  # SentinelOne manages this config file, but it needs to exist and be valid JSON
  # before augeas can add provided options. So, we just make sure it is created and
  # the exec should only run once when the file is empty.
  exec { 'initialize_basic_conf':
    command     => "echo '{}' > /opt/sentinelone/configuration/basic.conf",
    path        => '/bin:/usr/bin:/sbin:/usr/sbin',
    refreshonly => true,
    subscribe   => File['/opt/sentinelone/configuration/basic.conf'],
    unless      => 'test -s /opt/sentinelone/configuration/basic.conf',
  }

  # Set the URL and site-key separately
  sentinelone_agent::option { 'mgmt_site-key':
    value => $site_key,
  }
  sentinelone_agent::option { 'mgmt_url':
    value => $url,
  }

  if $sentinelone_agent::options {
    $sentinelone_agent::options.each |String $key, String $value| {
      case $key {
        'mgmt_site-key', 'mgmt_url', 'mgmt_uuid': {
          fail("option '${key}' cannot be set in options")
        }
        default: {}
      }
      sentinelone_agent::option { $key:
        value => $value,
      }
    }
  }

  if $sentinelone_agent::manage_logrotate {
    logrotate::rule { 'sentinelone_agent':
      ensure    => $sentinelone_agent::logrotate_ensure,
      compress  => true,
      dateext   => true,
      ifempty   => false,
      maxsize   => '100M',
      missingok => true,
      path      => [
        '/var/log/sentinelagent/*.log',
        '/var/log/sentinelagent/ui/*.log',
      ],
    }
  }
}
