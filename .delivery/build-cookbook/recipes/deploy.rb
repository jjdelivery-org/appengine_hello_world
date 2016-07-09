#
# Cookbook Name:: build-cookbook
# Recipe:: deploy
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

account_json = ::File.expand_path('/tmp/gcloud/service_account.json')

src_dir = File.expand_path("#{node['delivery']['workspace']['repo']}")

case node['delivery']['change']['stage']
when 'acceptance'
  git "#{src_dir}/#{node.default['appengine']['source_location']}" do
    repository node.default['appengine']['repository']
    reference  node.default['appengine']['branch']
    user 'dbuild'
    group 'dbuild'
    action :sync
  end

  appengine 'formal-platform-134918' do
    app_yaml "#{src_dir}/#{node.default['appengine']['source_location']}/app.yaml"
    service_id 'default'
    bucket_name 'chef-conf16-appengine'
    service_account_json account_json
    source "#{src_dir}/#{node.default['appengine']['source_location']}"
    # TODO(jj): Enable this once cookbook is updated to 0.0.9+
    # version_id "#{ENV['CHEF_PUSH_JOB_ID']}"
    action :stage
  end

when 'delivered'
  git "#{src_dir}/#{node.default['appengine']['source_location']}" do
    repository node.default['appengine']['repository']
    reference  node.default['appengine']['branch']
    user 'dbuild'
    group 'dbuild'
    action :sync
  end

  appengine 'formal-platform-134918' do
    app_yaml "#{src_dir}/#{node.default['appengine']['source_location']}/app.yaml"
    service_id 'default'
    bucket_name 'chef-conf16-appengine'
    service_account_json account_json
    source "#{src_dir}/#{node.default['appengine']['source_location']}"
    # TODO(jj): Enable this once cookbook is updated to 0.0.9+
    # version_id "#{ENV['CHEF_PUSH_JOB_ID']}"
  end
end
