#
# Cookbook Name:: base
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apt"
include_recipe "build-essential"

package "vim" do
  action :install
end
