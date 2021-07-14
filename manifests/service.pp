#
# @summary Manage the SentinelOne Agent service
#
class sentinelone_agent::service {
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
}
