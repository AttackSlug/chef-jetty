#
# Cookbook Name:: jetty
# Recipe:: default
#
# Copyright 2010, Jiva Technology Limited
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'java'

group node.jetty.group

user node.jetty.user do
  gid   node.jetty.group
  shell '/bin/false'
  home  node.jetty.home
end

remote_file node.jetty.download do
  source   node.jetty.link
  checksum node.jetty.checksum
  mode     0644
end

bash 'Unpack Jetty' do
  code   "tar xzf #{node.jetty.download} -C #{node.jetty.directory}"
  not_if "test -d #{node.jetty.extracted}"
end

bash 'Copy Jetty files' do
  code   "cp -R #{node.jetty.extracted} #{node.jetty.home}"
  not_if "test -d #{node.jetty.home}"
end

directory node.jetty.log_dir do
  owner node.jetty.user
  group node.jetty.group
  mode  '755'
  recursive true
end

execute "fixup jetty home owner" do
  command "chown -Rf #{node.jetty.user}:#{node.jetty.group} #{node.jetty.home}"
  only_if { Etc.getpwuid(File.stat(node.jetty.home).uid).name != node.jetty.user }
end

bash '/etc/init.d/jetty' do
  code "cp #{node.jetty.home}/bin/jetty.sh /etc/init.d/jetty"
  not_if "test -f /etc/init.d/jetty"
end

service 'jetty' do
  action :nothing
end

template '/etc/default/jetty' do
  source 'jetty.default.erb'
  mode   '644'
  notifies :restart, resources(:service => 'jetty')
end

#if node.jetty.port < 1024
#  include_recipe 'iptables'
#
#  node.set[:jetty][:real_port] = node.jetty.hidden_port
#
#  template "/etc/iptables.snat" do
#    source 'iptables.erb'
#    mode 0644
#    backup false
#    variables :source => node.jetty.port , :destination => node.jetty.hidden_port
#    notifies :run, resources(:execute => "rebuild-iptables")
#  end
#else
#  node.set[:jetty][:real_port] = node.jetty.port
#end

%w(jetty-logging.xml).each do |f|
  template "#{node.jetty.home}/etc/#{f}" do
    source "#{f}.erb"
    mode   '644'
    notifies :restart, resources(:service => 'jetty')
  end
end

service 'jetty' do
  action [:enable, :start]
end
