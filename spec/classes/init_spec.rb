require 'spec_helper'

describe 'sentinelone_agent' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'without token' do
        it do
          is_expected.not_to compile
        end
      end

      context 'with a provided token' do
        let(:environment) { 'unittest' }

        context 'with default values for all parameters' do
          it do
            is_expected.to compile.with_all_deps
          end
          it do
            is_expected.to contain_class('sentinelone_agent')
          end
          it do
            is_expected.to contain_class('sentinelone_agent::install')
          end
          it do
            is_expected.to contain_class('sentinelone_agent::config')
          end
          it do
            is_expected.to contain_class('sentinelone_agent::service')
          end

          it do
            is_expected.to contain_package('sentinelone_agent_package').with(
              ensure: 'installed',
              name: 'SentinelAgent',
            )
          end
          it do
            is_expected.to contain_service('sentinelone_agent_service').with(
              enable: true,
              ensure: 'running',
              name: 'sentinelone',
              require: 'Package[sentinelone_agent_package]',
            )
          end
          it do
            is_expected.to contain_sentinelone_agent__option('mgmt_site-key').with(value: 'abc123')
          end
          it do
            is_expected.to contain_sentinelone_agent__option('mgmt_url').with(value: 'http://example.org')
          end

          it do
            is_expected.to contain_logrotate__rule('sentinelone_agent').with(
              ensure: 'present',
              compress: true,
              dateext: true,
              ifempty: false,
              maxsize: '100M',
              missingok: true,
              path: [
                '/var/log/sentinelagent/*.log',
                '/var/log/sentinelagent/ui/*.log',
              ],
            )
          end
        end

        context 'with logrotate_ensure set to absent' do
          let(:params) do
            { logrotate_ensure: 'absent' }
          end

          it do
            is_expected.to contain_logrotate__rule('sentinelone_agent').with(
              ensure: 'absent',
              compress: true,
              dateext: true,
              ifempty: false,
              maxsize: '100M',
              missingok: true,
              path: [
                '/var/log/sentinelagent/*.log',
                '/var/log/sentinelagent/ui/*.log',
              ],
            )
          end
        end

        context 'with manage_logrotate set to false' do
          let(:params) do
            { manage_logrotate: false }
          end

          it do
            is_expected.not_to contain_logrotate__rule('sentinelone_agent')
          end
        end

        context 'with manage_package set to false' do
          let(:params) do
            { manage_package: false }
          end

          it do
            is_expected.not_to contain_package('sentinelone_agent_package')
          end
          it do
            is_expected.to contain_service('sentinelone_agent_service').with(
              enable: true,
              ensure: 'running',
              name: 'sentinelone',
              require: nil,
            )
          end
        end

        context 'with manage_service set to false' do
          let(:params) do
            { manage_service: false }
          end

          it do
            is_expected.not_to contain_service('sentinelone_agent_service')
          end
        end

        context 'with package_ensure set to absent' do
          let(:params) do
            { package_ensure: 'absent' }
          end

          it do
            is_expected.to contain_package('sentinelone_agent_package').with(
              ensure: 'absent',
              name: 'SentinelAgent',
            )
          end
        end

        context 'with package_name set to absent' do
          let(:params) do
            { package_name: 'sentineltwo' }
          end

          it do
            is_expected.to contain_package('sentinelone_agent_package').with(
              ensure: 'installed',
              name: 'sentineltwo',
            )
          end
        end

        context 'with service_enable set to false' do
          let(:params) do
            { service_enable: false }
          end

          it do
            is_expected.to contain_service('sentinelone_agent_service').with(
              enable: false,
              ensure: 'running',
              name: 'sentinelone',
              require: 'Package[sentinelone_agent_package]',
            )
          end
        end

        context 'with service_ensure set to false' do
          let(:params) do
            { service_ensure: 'stopped' }
          end

          it do
            is_expected.to contain_service('sentinelone_agent_service').with(
              enable: true,
              ensure: 'stopped',
              name: 'sentinelone',
              require: 'Package[sentinelone_agent_package]',
            )
          end
        end

        context 'with service_name set to sentinel-new' do
          let(:params) do
            { service_name: 'sentinel-new' }
          end

          it do
            is_expected.to contain_service('sentinelone_agent_service').with(
              enable: true,
              ensure: 'running',
              name: 'sentinel-new',
              require: 'Package[sentinelone_agent_package]',
            )
          end
        end

        context 'with package_ensure set to 1.2.3.4' do
          let(:params) do
            { package_ensure: '1.2.3.4' }
          end

          it do
            is_expected.to contain_package('sentinelone_agent_package').with(
              ensure: '1.2.3.4',
              name: 'SentinelAgent',
            )
          end
        end

        context 'with package_ensure set to 1.2.3' do
          let(:params) do
            { package_ensure: '1.2.3' }
          end

          it do
            is_expected.not_to compile
          end
        end

        context 'with package_ensure set to 1.2.3.4b' do
          let(:params) do
            { package_ensure: '1.2.3.4b' }
          end

          it do
            is_expected.not_to compile
          end
        end

        context 'with token set to new value' do
          let(:params) do
            { token: 'eyJ1cmwiOiAiaHR0cDovL25ldy5leGFtcGxlLm9yZyIsICJzaXRlX2tleSI6ICJ4eXozMjEifQ==' }
          end

          it do
            is_expected.to contain_sentinelone_agent__option('mgmt_site-key').with(value: 'xyz321')
          end
          it do
            is_expected.to contain_sentinelone_agent__option('mgmt_url').with(value: 'http://new.example.org')
          end
        end

        context 'with option set for mgmt_site-key' do
          let(:params) do
            { options: { 'mgmt_site-key': 'abc123' } }
          end

          it do
            is_expected.to compile.and_raise_error(%r{option 'mgmt_site-key' cannot be set in options})
          end
        end
        context 'with option set for mgmt_url' do
          let(:params) do
            { options: { mgmt_url: 'abc123' } }
          end

          it do
            is_expected.to compile.and_raise_error(%r{option 'mgmt_url' cannot be set in options})
          end
        end
        context 'with option set for mgmt_uuid' do
          let(:params) do
            { options: { mgmt_uuid: 'abc123' } }
          end

          it do
            is_expected.to compile.and_raise_error(%r{option 'mgmt_uuid' cannot be set in options})
          end
        end
      end
    end
  end
end
