require 'bundler/setup'
require 'dead_simple_conf'

# logger:
#   level: debug
#   output: /tmp/file.log
# 
# app:
#   data_path: /tmp
#   
#   server:
#     port: 9000
#     address: 127.0.0.1

module ConfigLoader
  class ServerConfig < DeadSimpleConf::ConfigBlock
    attr_accessor :port, :address
  end

  class AppConfig < DeadSimpleConf::ConfigBlock
    attr_accessor :data_path
    sub_section :server, ServerConfig
  
  end

  class LoggerConfig < DeadSimpleConf::ConfigBlock
    attr_accessor :level, :output
  end

  class MyConfig < DeadSimpleConf::ConfigBlock
    sub_section :app, AppConfig
    sub_section :logger, LoggerConfig  
  end
  
  def self.load(path)
    raw_data = YAML.load_file(path)
    MyConfig.new(raw_data)
  end
end

conf = ConfigLoader.load("conf.yml")
puts "conf.app.data_path    : #{conf.app.data_path}"
puts "conf.app.server.port  : #{conf.app.server.port}"
