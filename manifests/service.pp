#
# @summary Manage the SentinelOne Agent service
#
class sentinelone_agent::service {
  require ::logrotate

  # Token is just a base64-encoded string of JSON
  $token_pieces = parsejson(base64('decode', $sentinelone_agent::token))
  $site_key = $token_pieces['site_key']
  $url = $token_pieces['url']

  if $sentinelone_agent::manage_service {
    service { 'sentinelone_agent_service':
      ensure  => $sentinelone_agent::service_ensure,
      enable  => $sentinelone_agent::service_enable,
      name    => $sentinelone_agent::service_name,
      require => $sentinelone_agent::install::pkg_req,
    }
    $svc_req = Service['sentinelone_agent_service']
  } else {
    $svc_req = undef
  }

  # Require package installation first if the module controls the package
  # Don't execute if the sitekey is already correct on the system
  exec {'sentinelone_agent_token':
    command => "/usr/bin/sentinelctl management token set ${sentinelone_agent::token}",
    notify  => $svc_req,
    require => $sentinelone_agent::install::pkg_req,
    unless  => "/usr/bin/sentinelctl management status | /usr/bin/grep -E 'Site\\-Key\\s+${site_key}'",
    user    => 'root',
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
