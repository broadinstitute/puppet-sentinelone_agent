#
# @summary Manage an installation of the SentinelOne Agent
#
# @example
#    class { 'sentinelone_agent':
#      token => 'abc123',
#    }
#
# @param logrotate_ensure
#   Ensure whether the logrotate file is present or not (default: 'present').
#
# @param manage_logrotate
#   Decide whether to manage the logrotate configuration for the service (default: true).
#
# @param manage_package
#   Decide whether to manage the package (default: true).
#
# @param manage_service
#   Decide whether to manage the service (default: true).
#
# @param package_ensure
#   Ensure the state of the package (default: 'installed').
#
# @param package_name
#   The name of the SentinelOne agent package (default: 'SentinelAgent').
#
# @param service_enable
#   Decide whether to enable the service (default: true).
#
# @param service_ensure
#   Ensure the state of the service (default: 'running').
#
# @param service_name
#   The name of the SentinelOne agent service (default: 'sentineld').
#
# @param token
#   The token to be used by the SentinelOne agent (no default, but required)
#
class sentinelone_agent (
  Enum['absent', 'present'] $logrotate_ensure,
  Boolean $manage_logrotate,
  Boolean $manage_package,
  Boolean $manage_service,
  Variant[Enum['absent', 'installed', 'latest'], Pattern[/^(\d+\.){3}\d+$/]] $package_ensure,
  String $package_name,
  Boolean $service_enable,
  Enum['running', 'stopped'] $service_ensure,
  String $service_name,
  String $token,
) {
  contain 'sentinelone_agent::install'
  contain 'sentinelone_agent::service'

  Class['sentinelone_agent::install'] ~> Class['sentinelone_agent::service']
}
