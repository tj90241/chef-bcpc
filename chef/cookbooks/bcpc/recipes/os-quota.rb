#
# Cookbook Name:: bcpc
# Recipe:: os-quota
#
# Copyright 2018, Bloomberg Finance L.P.
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


node['bcpc']['cinder']['quota'].each do |quota, limit|
  execute "set openstack #{quota} quota" do
    environment (os_adminrc())
    retries 20
    command "openstack quota set --class --#{quota} #{limit} default"
  end
end

node['bcpc']['nova']['quota']['project'] do |project, quotas|
  quotas.each do |quota,limit|
    execute "set #{quota} quota for #{project} project" do
      environment (os_adminrc())
      retries 20
      command "openstack quota set --#{quota} #{limit} #{project}"
      not_if "openstack quota show -f value -c #{quota} #{project} | grep -w #{limit}"
    end
  end
end