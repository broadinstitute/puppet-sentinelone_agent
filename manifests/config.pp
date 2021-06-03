#
# @summary Manage the SentinelOne Agent configuration
#
class sentinelone_agent::config {
  require ::logrotate

  # Token is just a base64-encoded string of JSON
  $token_pieces = parsejson(base64('decode', $sentinelone_agent::token))
  $site_key = $token_pieces['site_key']
  $url = $token_pieces['url']

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
