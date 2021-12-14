require 'spec_helper'

describe 'sentinelone_agent::option' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:environment) { 'unittest' }

      context 'with default agent settings' do
        let(:pre_condition) do
          "class { 'sentinelone_agent': }"
        end

        context 'with an alphanumeric title' do
          let(:title) { 'mgmt_proxy_url' }

          context 'with a value' do
            let(:params) { { value: 'http://example.com:8888' } }

            it do
              is_expected.to compile.with_all_deps
            end

            it do
              is_expected.to contain_augeas('sentinelone_agent_option_add_mgmt_proxy_url').with(
                changes: [
                  'set dict/entry[last()+1] mgmt_proxy_url',
                  "set dict/entry[.= 'mgmt_proxy_url']/string 'http://example.com:8888'",
                ],
                context: '/files/opt/sentinelone/configuration/basic.conf',
                incl: '/opt/sentinelone/configuration/basic.conf',
                lens: 'Json.lns',
                onlyif: "match dict/entry[.= 'mgmt_proxy_url'] size == 0",
                notify: 'Service[sentinelone_agent_service]',
                require: 'File[/opt/sentinelone/configuration/basic.conf]',
              )
            end
            it do
              is_expected.to contain_augeas('sentinelone_agent_option_update_mgmt_proxy_url').with(
                changes: "set dict/entry[.= 'mgmt_proxy_url']/string 'http://example.com:8888'",
                context: '/files/opt/sentinelone/configuration/basic.conf',
                incl: '/opt/sentinelone/configuration/basic.conf',
                lens: 'Json.lns',
                onlyif: "get dict/entry[.= 'mgmt_proxy_url']/string != 'http://example.com:8888'",
                notify: 'Service[sentinelone_agent_service]',
                require: 'File[/opt/sentinelone/configuration/basic.conf]',
              )
            end
          end

          context 'with a value and custom setting name' do
            let(:params) { { setting: 'new_proxy_url', value: 'http://example.com:8888' } }

            it do
              is_expected.to compile.with_all_deps
            end

            it do
              is_expected.to contain_augeas('sentinelone_agent_option_add_new_proxy_url').with(
                changes: [
                  'set dict/entry[last()+1] new_proxy_url',
                  "set dict/entry[.= 'new_proxy_url']/string 'http://example.com:8888'",
                ],
                context: '/files/opt/sentinelone/configuration/basic.conf',
                incl: '/opt/sentinelone/configuration/basic.conf',
                lens: 'Json.lns',
                onlyif: "match dict/entry[.= 'new_proxy_url'] size == 0",
                notify: 'Service[sentinelone_agent_service]',
                require: 'File[/opt/sentinelone/configuration/basic.conf]',
              )
            end
            it do
              is_expected.to contain_augeas('sentinelone_agent_option_update_new_proxy_url').with(
                changes: "set dict/entry[.= 'new_proxy_url']/string 'http://example.com:8888'",
                context: '/files/opt/sentinelone/configuration/basic.conf',
                incl: '/opt/sentinelone/configuration/basic.conf',
                lens: 'Json.lns',
                onlyif: "get dict/entry[.= 'new_proxy_url']/string != 'http://example.com:8888'",
                notify: 'Service[sentinelone_agent_service]',
                require: 'File[/opt/sentinelone/configuration/basic.conf]',
              )
            end
          end
          context 'without a value' do
            it do
              is_expected.not_to compile
            end
          end
        end
      end
      context 'with manage_service set to false' do
        let(:pre_condition) do
          "class { 'sentinelone_agent': manage_service => false }"
        end

        context 'with an alphanumeric title' do
          let(:title) { 'mgmt_proxy_url' }

          context 'with a value' do
            let(:params) { { value: 'http://example.com:8888' } }

            it do
              is_expected.to compile.with_all_deps
            end

            it do
              is_expected.to contain_augeas('sentinelone_agent_option_add_mgmt_proxy_url').with(
                changes: [
                  'set dict/entry[last()+1] mgmt_proxy_url',
                  "set dict/entry[.= 'mgmt_proxy_url']/string 'http://example.com:8888'",
                ],
                context: '/files/opt/sentinelone/configuration/basic.conf',
                incl: '/opt/sentinelone/configuration/basic.conf',
                lens: 'Json.lns',
                onlyif: "match dict/entry[.= 'mgmt_proxy_url'] size == 0",
                notify: nil,
                require: 'File[/opt/sentinelone/configuration/basic.conf]',
              )
            end
            it do
              is_expected.to contain_augeas('sentinelone_agent_option_update_mgmt_proxy_url').with(
                changes: "set dict/entry[.= 'mgmt_proxy_url']/string 'http://example.com:8888'",
                context: '/files/opt/sentinelone/configuration/basic.conf',
                incl: '/opt/sentinelone/configuration/basic.conf',
                lens: 'Json.lns',
                onlyif: "get dict/entry[.= 'mgmt_proxy_url']/string != 'http://example.com:8888'",
                notify: nil,
                require: 'File[/opt/sentinelone/configuration/basic.conf]',
              )
            end
          end
        end
      end
    end
  end
end
