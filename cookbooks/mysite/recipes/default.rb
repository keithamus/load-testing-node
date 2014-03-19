if not node.mysite.application.development
  # stops mysite service if running
  service 'mysite' do
    action :stop
    provider Chef::Provider::Service::Upstart
  end

  # provisions system user to run application
  user node.mysite.application.user do
    system true
    shell '/bin/false'
    home '/home/mysite'
    supports :manage_home => true
  end

  # provisions deploy directory with app user permissions
  directory node.mysite.application.deploy_path  do
    owner node.mysite.application.user
    group node.mysite.application.user
  end

  # provisions log directory with app user permissions
  directory node.mysite.application.log_path  do
    owner node.mysite.application.user
    group node.mysite.application.user
  end

  # provisions source
  remote_directory node.mysite.application.deploy_path  do
    source node.mysite.application.source_path
    files_owner node.mysite.application.user
    files_group node.mysite.application.user
    user node.mysite.application.user
    group node.mysite.application.user
    files_mode "0440"
    mode "0770"
  end

  # provisions npm application dependencies
  execute 'npm install --production' do
    cwd node.mysite.application.deploy_path
    command '/usr/bin/npm install --production'
    user node.mysite.application.user
    group node.mysite.application.user
    env 'HOME' => "/home/#{node.mysite.application.user}"
  end

  # provisions upstart script
  template '/etc/init/mysite.conf' do
    source 'mysite.conf.erb'
    mode 0440
  end
  template '/etc/init/mysite-worker.conf' do
    source 'mysite-worker.conf.erb'
    mode 0440
  end

  # provisions varnish config
  template '/etc/default/varnish' do
    source 'varnish.conf.erb'
    mode 0440
  end

  # provisions varnish vcl config
  template '/etc/varnish/default.vcl' do
    source 'node.vcl.erb'
    mode 0440
  end

  # starts mysite service
  service 'mysite' do
    action :start
    provider Chef::Provider::Service::Upstart
  end

  # starts mysite service
  service 'varnish' do
    action :restart
    provider Chef::Provider::Service::Init::Debian
  end

end
