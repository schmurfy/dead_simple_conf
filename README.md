
This is my own implementation of a REALLY simple configuration library, and
when I say simple I mean it ! Most of the library available out there are far
too complicated.

I decided to extract this code in a proper gem when I got tired of copying it over
and over in my projects.

# Continuous integration ([![Build Status](https://secure.travis-ci.org/schmurfy/dead_simple_conf.png)](http://travis-ci.org/schmurfy/dead_simple_conf))

This gem is tested against these ruby by travis-ci.org:

- mri 1.9.2
- mri 1.8.7

# What this gem provides

My requirements for a config parser are:

- check that each line typed in the yaml file match a valid parameter
  I spent far too much time debugging application loading just because
  activerecord or any other gem did not warned me that a key was unknown
  (like "size" instead of "pool_size", you get the idea).  
  What I expect is to have some return, taise an error, throw me a brick, do something damn !

- have a useable syntax to read the values
- something minimal which can be extended as needed (look at the source
  to really figure out how small this library is, there may even be more text
  in this README ! )

And honestly that's all, I don't want or need 100 different allowed formats
with complex cases handled, so now that we are clear let's see how this
thing works.



# How it works

You have this yaml file:

```yaml

logger:
  level: debug
  output: /tmp/file.log

app:
  data_path: /tmp
  
  server:
    port: 9000
    address: 127.0.0.1
```

Here is how you would use it:

```ruby
require 'bundler/setup'
require 'dead_simple_conf'

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

```

You can see both files in the examples folder.


# Extending it

Since I am only using standard class with getter and setters you should be able to extend it
without much trouble, one one the thing which comes in mind is to use activemodel validation
to validate incoming entries.

