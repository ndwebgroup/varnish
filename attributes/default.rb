##
## Resource settings
##

if platform_family?('debian')
  default['varnish']['conf_path'] = '/etc/default/varnish'
  default['varnish']['reload_cmd'] = '/usr/share/varnish/reload-vcl'
else
  default['varnish']['conf_path'] = '/etc/sysconfig/varnish'
  default['varnish']['reload_cmd'] = '/usr/sbin/varnish_reload_vcl'
end

if node['init_package'] == 'init'
  default['varnish']['conf_source'] = 'default.erb'
elsif node['init_package'] == 'systemd'
  # Ubuntu >= 15.04, Debian >= 8, CentOS >= 7
  default['varnish']['conf_source'] = 'default_systemd.erb'
  default['varnish']['conf_path'] = '/etc/systemd/system/varnish.service'
else
  default['varnish']['conf_source'] = 'default.erb'
end

default['varnish']['conf_cookbook'] = 'varnish'

default['varnish']['major_version'] = 4.1

##
## varnish::configure recipe settings
##
## This recipe uses namespaced attributes to configure resources.
##
## Resource                   | Attribute Namespace
## ---------------------------|------------------------
## varnish_repo   'configure' | node['varnish']['configure']['repo']
## package        'varnish'   | node['varnish']['configure']['package']
## service        'varnish'   | node['varnish']['configure']['service']
## varnish_config 'default'   | node['varnish']['configure']['config']
## vcl_template   'default'   | node['varnish']['configure']['vcl_template']
## varnish_log    'default'   | node['varnish']['configure']['log']
## varnish_log    'ncsa'      | node['varnish']['configure']['ncsa']
##

# Disable vendor repo:
# override['varnish']['configure']['repo']['action'] = :nothing

# Install specific varnish version:
# override['varnish']['configure']['package']['version'] = '4.1.1-1~trusty'

# Disable logs:
# override['varnish']['configure']['log']['action'] = :nothing

default['varnish']['configure']['repo']['action'] = :configure

default['varnish']['configure']['package']['action'] = :install

default['varnish']['configure']['service']['action'] = [:start, :enable]

default['varnish']['configure']['config']['action'] = :configure

default['varnish']['configure']['vcl_template']['source']    = 'default.vcl.erb'
default['varnish']['configure']['vcl_template']['variables'] = {
  config: {
    backend_host: '127.0.0.1',
    backend_port: '8080',
    'VARNISH_LISTEN_PORT': '6081',
    'VARNISH_BACKEND_PORT': '80',
    'VARNISH_BACKEND_ADDRESS': '127.0.0.1',
    'VARNISH_ADMIN_LISTEN_ADDRESS': '127.0.0.1',
    'VARNISH_ADMIN_LISTEN_PORT': '6082',
    'VARNISH_SECRET_FILE': '/etc/varnish/secret',
    'VARNISH_MIN_THREADS': '1',
    'VARNISH_MAX_THREADS': '1000',
    'VARNISH_THREAD_TIMEOUT': '120',
    'VARNISH_STORAGE_FILE': '/var/lib/varnish/varnish_storage.bin',
    'VARNISH_STORAGE_SIZE': '1G',
    'VARNISH_STORAGE': 'malloc',
    'VARNISH_TTL': '120',
    'VARNISH_WORKING_DIR': '',
    'VARNISH_UID_SWITCH': 'true',
    'GeoIP_enabled': 'false',
    'version': '4.0'
  },
}



default['varnish']['configure']['log'] = {}

default['varnish']['configure']['ncsa']['action'] = :nothing
