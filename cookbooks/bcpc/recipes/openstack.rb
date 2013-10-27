#
# Cookbook Name:: bcpc
# Recipe:: openstack
#
# Copyright 2013, Bloomberg Finance L.P.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "bcpc::default"

package "ubuntu-cloud-keyring" do
    action :upgrade
end

apt_repository "openstack" do
    uri node['bcpc']['repos']['openstack']
    distribution "#{node['lsb']['codename']}-#{node['bcpc']['openstack_branch']}/#{node['bcpc']['openstack_release']}"
    components ["main"]
end

%w{python-novaclient python-cinderclient python-glanceclient nova-common python-nova
   python-keystoneclient python-nova-adminclient python-heatclient python-mysqldb}.each do |pkg|
        package pkg do
            action :upgrade
        end
end

template "/usr/local/bin/hup_openstack" do
    source "hup_openstack.erb"
    mode 0755
    owner "root"
    group "root"
end

directory "/opt/openstack" do
    owner "root"
    group "root"
    mode 00755
end
