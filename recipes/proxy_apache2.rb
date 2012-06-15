include_recipe "apache2"

apache_module "proxy"
apache_module "proxy_http"
apache_module "vhost_alias"

template "#{node[:apache][:dir]}/sites-available/solr" do
  source      "apache_solr.erb"
  owner       'root'
  group       'root'
  mode        '0644'
  variables(
    :host_name        => node[:fqdn]
  )

  if File.exists?("#{node[:apache][:dir]}/sites-enabled/solr")
    notifies  :restart, 'service[apache2]'
  end
end

apache_site "000-default" do
  enable  false
end

apache_site "solr" do
  enable true
end

