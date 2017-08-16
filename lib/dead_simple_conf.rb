require "dead_simple_conf/version"

module DeadSimpleConf
  
  class ConfigBlock
    
    def self.sub_section(name, klass)
      attr_reader(name)
      
      define_method("#{name}=") do |h|
        instance_variable_set("@#{name}", klass.new(h))
      end
    end
    
    def self.sub_array(name, klass)
      attr_reader(name)
      
      define_method("#{name}=") do |arr|
        res = arr.map{|itm| klass.new(itm) }
        instance_variable_set("@#{name}", res)
      end
    end
    
    def initialize(attributes)
      _load_data(attributes)
    end

    def _load_data(attributes)
      unknown = attributes.reject do |key, value|
        if respond_to?("#{key}=")
          send("#{key}=", value)
          true
        else
          false
        end
      end

      unless unknown.empty?
        fail "unknown parameter(s) in config block #{self.class}: #{unknown.inspect}"
      end
    end
    
  end
  
end
