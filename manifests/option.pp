#
# @summary Control an option in the SentinelOne Agent configuration file
#
# @example
#   sentinelone_agent::option { 'mgmt_proxy_url':
#     value => 'http://example.org:8888',
#   }
#
# @example
#   sentinelone_agent::option { 'some_option_name':
#     setting => 'mgmt_proxy_url'
#     value   => 'http://example.org:8888',
#   }
#
# @param value
#   The value to set for the given option.
#
# @param setting
#   Optionally set the option name. If not provided, the resource title will be used.
#
define sentinelone_agent::option (
  String $value,
  Optional[String] $setting = undef,
){
  $key = pick_default($setting, $title)

  # Use Augeas to get around password prompts on option changes

  # Used to add new key to the config
  augeas { "sentinelone_agent_option_add_${key}":
    changes => [
      "set dict/entry[last()+1] ${key}",
      "set dict/entry[.= '${key}']/string '${value}'",
    ],
    context => '/files/opt/sentinelone/configuration/basic.conf',
    incl    => '/opt/sentinelone/configuration/basic.conf',
    lens    => 'Json.lns',
    onlyif  => "match dict/entry[.= '${key}'] size == 0",
    notify  => $sentinelone_agent::service::svc_req,
    require => File['/opt/sentinelone/configuration/basic.conf'],
  }

  # Used to update a pre-existing key in the JSON
  augeas { "sentinelone_agent_option_update_${key}":
    changes => "set dict/entry[.= '${key}']/string '${value}'",
    context => '/files/opt/sentinelone/configuration/basic.conf',
    incl    => '/opt/sentinelone/configuration/basic.conf',
    lens    => 'Json.lns',
    onlyif  => "get dict/entry[.= '${key}']/string != '${value}'",
    notify  => $sentinelone_agent::service::svc_req,
    require => File['/opt/sentinelone/configuration/basic.conf'],
  }
}
