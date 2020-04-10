#
# Cookbook:: rabbitmq
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.
execute 'yum update' do
    command 'yum -y update'
  end
  
  execute 'yum install packages' do
    command 'yum -y install bind-tools htop telnet net-tools vim git wget jq'
  end
  
  include_recipe 'rabbitmq::systemd_limits'
  
  include_recipe 'rabbitmq::default'
  
  include_recipe 'rabbitmq::mgmt_console'
  include_recipe 'rabbitmq::user_management'
  include_recipe 'rabbitmq::virtualhost_management'
  include_recipe 'rabbitmq::policy_management'
  
  RABBITPASS = data_bag_item('rabbitmq','svadmin')
  
  rabbitmq_user 'svadmin' do # create admin user
    password RABBITPASS['password']
    action :add
  end
  
  rabbitmq_user 'svadmin' do # give admin permissions on mgmt GUI
    tag 'administrator'
    action :set_tags
  end
  
  rabbitmq_user 'svadmin' do 
    vhost '/'
    permissions '.* .* .*'
    action :set_permissions
  end
  
  rabbitmq_user 'guest' do
    action :delete
  end
  
  