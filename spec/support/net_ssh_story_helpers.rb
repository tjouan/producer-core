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
    yield
    expect(socket.script.events)
      .to be_empty, "#{socket.script.events.count} story events still pending"
  end
end
