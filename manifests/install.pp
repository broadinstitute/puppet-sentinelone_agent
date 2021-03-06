#
# @summary Manage the SentinelOne Agent installation
#
class sentinelone_agent::install {
  if $sentinelone_agent::manage_package {
    $pkg_req = Package['sentinelone_agent_package']
    package { 'sentinelone_agent_package':
      ensure => $sentinelone_agent::package_ensure,
      name   => $sentinelone_agent::package_name,
    }
  } else {
    $pkg_req = undef
  }
}
