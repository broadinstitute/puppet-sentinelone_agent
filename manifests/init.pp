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
# @param options
#   Custom options to be changed in the SentinelOne Agent configuration
#
# @param package_ensure
#   Ensure the state of the package (default: 'installed').
#
# @param package_name
#   The name of the SentinelOne agent package (default: 'SentinelAgent').
#
# @param package_install_options
#   Optional install arguments for the SentinelOne agent package
#
# @param service_enable
#   Decide whether to enable the service (default: true).
#
# @param service_ensure
#   Ensure the state of the service (default: 'running').
#
# @param service_name
#   The name of the SentinelOne agent service (default: 'sentinelone').
#
# @param token
#   The token to be used by the SentinelOne agent (no default, but required)
#
class sentinelone_agent (
  Enum['absent', 'present'] $logrotate_ensure,
  Boolean $manage_logrotate,
  Boolean $manage_package,
  Boolean $manage_service,
  Optional[Hash] $options,
  Variant[Enum['absent', 'installed', 'latest'], Pattern[/^(\d+\.){3}\d+$/]] $package_ensure,
  Optional[Array[Variant[String, Hash[String, String]]]] $package_install_options,
  String $package_name,
  Boolean $service_enable,
  Enum['running', 'stopped'] $service_ensure,
  String $service_name,
  String $token,
) {
  contain 'sentinelone_agent::install'
  contain 'sentinelone_agent::config'
  contain 'sentinelone_agent::service'
}
