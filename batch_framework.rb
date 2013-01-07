# Copyight (c) 2012 Kenichi Kamiya

require 'striuct'
require 'net/ssh'
require 'net/sftp'

$VERBOSE = true

Batch = Striuct.define do

  class << self

    # @param [Hash] attrs
    # @return [void]
    def run(attrs={}, &block)
      instance = for_pairs attrs
      Net::SSH.start instance.address, instance.loginname, password: instance.password do |ssh_session|
        instance.ssh_session = ssh_session
        begin
          instance.setup
          instance.instance_exec(&block)
        ensure
          instance.teardown
        end
      end

      nil
    end

  end

  member :address, String
  member :loginname, String
  member :password, String
  member :ssh_session, Net::SSH::Connection::Session
  alias_member :ssh, :ssh_session
  
  # @abstract
  def setup
  end
  
  # @return [String] path
  # @return [String] local_path
  def download(path)
    local_path = File.basename path
    Net::SFTP.start address, loginname, password: password do |sftp|
      sftp.download path, local_path
    end
    local_path
  end
  
  # @abstract
  def teardown
  end

end

class ExampleBatch < Batch
  
  def archive
    ssh.exec!('/home/tester/batch_test/archive.sh').chomp
  end

end

attrs = {address: '192.168.1.1', loginname: 'tester', password: 'test_password'}

ExampleBatch.run attrs do
  archive_path = archive
  puts '----'
  p archive_path
  puts '----'
  download archive_path
end