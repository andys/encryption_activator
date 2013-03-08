require 'io/console'

module EncryptionActivator

  class KeyNotSetException < Exception ; end

  class << self
    attr_writer :key

    def prompt(tty=STDIN)
      if tty.tty?
        attempt1 = nil
        3.times do
          $stderr.print "Enter key: "
          attempt1 = tty.noecho(&:gets).chomp
          if attempt1.length < 20
            $stderr.puts "not long enough, minimum 20 chars"
            next
          end

          $stderr.print "\n  Confirm: "
          attempt2 = tty.noecho(&:gets).chomp

          if attempt1 == attempt2
            self.key = attempt1
            break
          end
          $stderr.puts "did not match, try again"
        end
      end
    end

    def keyproc
      lambda {|*opts| @key || ENV['ENCRYPTION_ACTIVATOR_KEY'] || raise(EncryptionActivator::KeyNotSetException.new("Key not set!")) }
    end

    def key
      keyproc.call
    end
  end
end

