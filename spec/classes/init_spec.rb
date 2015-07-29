require 'spec_helper'
describe 'deploy' do

  # Set facts so this works on CentOS
  let (:facts) { {:osfamily => 'RedHat', :operatingsystem => 'CentOS', :operatingsystemrelease => '7.1.1503'} }
  context 'with defaults for all parameters' do
    it { should contain_class('deploy') }
  end
end
