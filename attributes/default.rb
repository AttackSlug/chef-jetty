default[:jetty][:version]   = "9.0.5.v20130815"
default[:jetty][:link]      = "http://download.eclipse.org/jetty/#{jetty.version}/dist/jetty-distribution-#{jetty.version}.tar.gz"
default[:jetty][:checksum]  = "5cb0f0c8a16e90cb15a4bdeef44eab0d92d1326af1fb4433dc266ca146d5dd82" # SHA256
default[:jetty][:directory] = "/usr/local/src"
default[:jetty][:download]  = "#{jetty.directory}/jetty-distribution-#{jetty.version}.tar.gz"
default[:jetty][:extracted] = "#{jetty.directory}/jetty-distribution-#{jetty.version}"

default[:jetty][:user]      = "jetty"
default[:jetty][:group]     = "jetty"
default[:jetty][:home]      = "/opt/jetty"
default[:jetty][:port]      = 8983
default[:jetty][:hidden_port] = 8983 if jetty.port.to_i < 1024

default[:jetty][:log_dir]   = "/var/log/jetty"
#default[:jetty][:cache]     = "/var/cache/jetty"
