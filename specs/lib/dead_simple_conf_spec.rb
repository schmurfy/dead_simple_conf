require File.expand_path('../../common', __FILE__)

describe 'DeadSimpleConf' do
  
  describe 'one level config' do
    before do
      @conf_data = YAML.load(%{
        login: user_login
        path: /tmp
      })
    end

    should 'raise an error on unknown parameter' do
      parser_module = Module.new do
        class MainBlock < DeadSimpleConf::ConfigBlock
          attr_accessor :login
        end

        def self.load(data)
          MainBlock.new(data)
        end
      end

      proc {
        result = parser_module.load(@conf_data)
      }.should.raise(RuntimeError)

    end

    should 'parse successfully known parameter' do
      parser_module = Module.new do
        class MainBlock < DeadSimpleConf::ConfigBlock
          attr_accessor :login, :path
        end

        def self.load(data)
          MainBlock.new(data)
        end
      end

      result = parser_module.load(@conf_data)
      result.login.should == "user_login"
      result.path.should == "/tmp"
    end
  end
  
  describe 'array subsections' do
    before do
      @conf_data = YAML.load(%{
        login: user_login
        path: /tmp
        
        servers:
          - address: 127.0.0.1
            port: 5000
          - address: 1.2.3.4
            port: 42
      })
    end
    
    should 'parse it with correct loader' do
      class ServersSectionBlock < DeadSimpleConf::ConfigBlock
        attr_accessor :address, :port
      end
      
      main_block = Class.new(DeadSimpleConf::ConfigBlock) do
        attr_accessor :login, :path
        sub_array :servers, ServersSectionBlock
      end
      
      data = main_block.new(@conf_data)
      data.login.should == "user_login"
      data.path.should == "/tmp"
      
      data.servers.size.should == 2
      data.servers[0].tap do |s|
        s.address.should == '127.0.0.1'
        s.port.should == 5000
      end
      
      data.servers[1].tap do |s|
        s.address.should == '1.2.3.4'
        s.port.should == 42
      end
    end
  end
  
  describe 'multi level config' do
    before do
      @conf_data = YAML.load(%{
        login: user_login
        path: /tmp
        
        server:
          address: 127.0.0.1
          port: 5000
          
          another_section:
            name: out_of_ideas
      })
    end
    
    should 'parse it with correct loader' do
      parser_module = Module.new do
        class AnotherSectionBlock < DeadSimpleConf::ConfigBlock
          attr_accessor :name
        end
        
        class ServerBlock < DeadSimpleConf::ConfigBlock
          attr_accessor :address, :port
          sub_section :another_section, AnotherSectionBlock
        end
        
        class MainBlock < DeadSimpleConf::ConfigBlock
          attr_accessor :login, :path
          sub_section :server, ServerBlock
        end

        def self.load(data)
          MainBlock.new(data)
        end
      end
      
      result = parser_module.load(@conf_data)
      result.login.should == "user_login"
      result.path.should == "/tmp"
      
      result.server.address.should == "127.0.0.1"
      result.server.port.should == 5000
      
      result.server.another_section.name.should == "out_of_ideas"
      
    end
    
  end
  
end
