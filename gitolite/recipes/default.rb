#
# Cookbook Name:: gitolite
# Recipe:: default
#
# Copyright 2010, RailsAnt, Inc.
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
# 
::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
include_recipe "git::default"

gem_package "ruby-shadow" do
  action :install
  source "http://rubygems.org"
end

node.set_unless['gitolite']['password'] = secure_password
user "git" do
  comment "Git User"
  home "/home/git"
  shell "/bin/bash"
  password node[:gitolite][:password]
end

directory "/home/git" do
  owner "git"
  group "git"
  mode "0755"
end

directory "/home/git/bin" do
  owner "git"
  group "git"
  mode "0755"
end

git "/home/git/gitolite" do
  repository node[:gitolite][:repository_url]
  branch "master"
  action :sync
  user "git"
end

execute "ssh-keygen -q -f /home/git/.ssh/id_rsa -N \"\" " do
  user "git"
  action :run
  not_if {File.exist? '/home/git/.ssh/id_rsa.pub'}
end

execute "ssh-keyscan -t rsa localhost > /home/git/.ssh/known_hosts" do
  user "git"
  action :run
  not_if {File.exist? '/home/git/.ssh/known_hosts'}
end

execute "/home/git/gitolite/install -ln" do
  user "git"
  group "git"
  environment ({'HOME' => '/home/git'})
  cwd "/home/git"
  not_if {File.exists?("/home/git/bin/gitolite") }
end

execute "/home/git/bin/gitolite setup -pk /home/git/.ssh/id_rsa.pub" do
  user "git"
  group "git"
  environment ({'HOME' => '/home/git'})
  cwd "/home/git"
  not_if {File.exists?("/home/git/repositories") }
end

git "/home/git/gitolite-admin" do
  repository "git@localhost:gitolite-admin"
  branch "master"
  action :sync
  user "git"
end
