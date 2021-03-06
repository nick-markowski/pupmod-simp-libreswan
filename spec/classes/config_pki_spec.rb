require 'spec_helper'

describe 'libreswan::config::pki' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "with pki true libreswan::config should init NSS db and copy certs" do
          let(:pre_condition) {
            "class { 'libreswan':
              service_name            => 'ipsec',
              pki                     => true,
              app_pki_external_source => '/etc/pki/simp-test',
              app_pki_dir             => '/etc/foo'
            }"
          }

          it { is_expected.to create_libreswan__nss__init_db('NSSDB /etc/ipsec.d').with({
            :require  => 'File[/etc/ipsec.conf]'
            })
          }
          it { is_expected.to create_file('/etc/foo').with({
              :ensure  => 'directory',
            })
          }
          it { is_expected.to create_pki__copy('/etc/foo').with({
            :require  => 'File[/etc/foo]',
            })
          }
          it { is_expected.to_not create_class('pki') }
        end

        context "with pki false libreswan::config should init NSS db and copy certs" do
          let(:pre_condition) {
            "class { 'libreswan':
               service_name => 'ipsec',
               pki => false,
               app_pki_dir => '/etc/foo' }"
            }
          let(:hieradata) { 'test1_hiera' }

          it { is_expected.to create_libreswan__nss__init_db('NSSDB /etc/ipsec.d').with({
            :require  => 'File[/etc/ipsec.conf]'
            })
          }
          it { is_expected.to create_file('/etc/foo/pki').with({
              :ensure  => 'directory',
            })
          }
          it { is_expected.to_not create_pki__copy('/etc/foo') }
          it { is_expected.to_not create_class('pki') }
        end

        context "with pki true libreswan::config should init NSS db and copy certs" do
          let(:pre_condition) { 'class { "libreswan": service_name => "ipsec",
            pki => "simp", app_pki_external_source => "/etc/pki/simp-test", app_pki_dir => "/etc/foo" }'}

          it { is_expected.to create_libreswan__nss__init_db('NSSDB /etc/ipsec.d').with({
            :require  => 'File[/etc/ipsec.conf]'
            })
          }
          it { is_expected.to create_file('/etc/foo').with({
              :ensure  => 'directory',
            })
          }
          it { is_expected.to create_pki__copy('/etc/foo').with({
            :require  => 'File[/etc/foo]',
            })
          }
          it { is_expected.to create_class('pki') }
        end

      end
    end
  end
end
