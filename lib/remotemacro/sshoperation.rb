require 'forwardable'
require 'striuct'
require 'net/ssh'
require 'net/sftp'
require 'net/ssh/shell'

module RemoteMacro

  # @example
  #   class DailyOperation < RemoteMacro::SSHOperation
  #     def excute_batch!
  #       shell do |sh|
  #         sh.excute! 'cd /tmp'
  #         sh.excute './batch.sh' do |_, output|
  #           unless output.chomp == 'Completed!'
  #             raise Error, "/tmp/batch.sh\n#{output}"
  #           end
  #         end
  #         sh.excute! 'exit'
  #       end
  #     end
  #   end
  # 
  #   attrs = {address: '192.168.1.1', loginname: 'tester', password: 'test_password'}
  # 
  #   DailyOperation.run attrs do
  #     excute_batch!
  #     download! '/tmp/batch.log'
  #   end
  SSHOperation = Striuct.define do
    
    extend Forwardable
    include Net::SSH::Loggable

    class << self

      # @param [Hash] attrs
      # @return [SSHOperation]
      def run(attrs={}, &block)
        for_pairs(attrs).run(&block)
      end

    end

    member :address, String
    alias_member :host, :address
    member :loginname, String
    member :password, String
    member :session, Net::SSH::Connection::Session
    alias_member :ssh, :session
    
    def_delegators :session, :shell

    # @return [self]
    def run(&block)
      Net::SSH.start address, loginname, password: password do |session|
        self.session = session
        self.logger = session.logger
        begin
          setup
          instance_exec(&block)
        ensure
          teardown
        end
      end

      self
    end
    
    # @abstract
    def setup
    end
    
    # @param [String] path
    # @return [String] local_path
    def download!(path)
      local_path = File.basename path
      Net::SFTP.start address, loginname, password: password do |sftp|
        sftp.download! path, local_path
      end
      local_path
    end
    
    # @abstract
    def teardown
    end

  end

end