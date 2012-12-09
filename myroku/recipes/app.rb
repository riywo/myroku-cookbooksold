#
# Cookbook Name:: myroku
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

gem_package "ruby-llenv" do
  action :install
end

gem_package "bundler" do
  action :install
end
