require 'minitest/autorun'
require 'pty'
require "#{File.dirname(__FILE__)}/../lib/encryption_activator"

class TestEncryptionActivator < MiniTest::Unit::TestCase

  def setup
    EncryptionActivator.key = nil
    ENV['ENCRYPTION_ACTIVATOR_KEY'] = nil
  end

  def test_key_entry_good
    k = 'flibbleflibbleflibble'
    PTY.open do |m, s|
      2.times { s.puts(k) }
      EncryptionActivator.prompt(m)
    end
    assert_equal k, EncryptionActivator.key
  end

  def test_key_entry_blank
    PTY.open do |m, s|
      Thread.new { loop { s.puts("") } }
      EncryptionActivator.prompt(m)
    end
    assert_raises(EncryptionActivator::KeyNotSetException) { EncryptionActivator.key }
  end

  def test_keyproc_nokey
    assert_raises(EncryptionActivator::KeyNotSetException) { EncryptionActivator.key }
  end  

  def test_keyprocx
    EncryptionActivator.key = 'flibble'
    assert_equal 'flibble', EncryptionActivator.key
  end  
  
  def test_key_env_var
    ENV['ENCRYPTION_ACTIVATOR_KEY'] = 'flibble'
    assert_equal 'flibble', EncryptionActivator.key
  end  
  
end
