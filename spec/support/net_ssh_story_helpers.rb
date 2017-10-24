require 'net/ssh/test'

if Net::SSH::Version::CURRENT >= Net::SSH::Version[2, 8, 0]
  module Net
    module SSH
      module Test
        class Socket
          def open(host, port, connections_options = nil)
            @host, @port = host, port
            self
          end
        end
      end
    end
  end
end

module NetSSHStoryHelpers
  include Net::SSH::Test

  def story_with_new_channel
    story do |session|
      ch = session.opens_channel
      yield ch
      ch.gets_close
      ch.sends_close
    end
  end

  def expect_story_completed
    raise 'there is no story to expect' if socket.script.events.empty?
    if Net::SSH::Test::Extensions::IO.respond_to? :with_test_extension
      Net::SSH::Test::Extensions::IO.with_test_extension { yield }
    else
      yield
    end
    expect(socket.script.events)
      .to be_empty, "#{socket.script.events.count} story events still pending"
  end
end
