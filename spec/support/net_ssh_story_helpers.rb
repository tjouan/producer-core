module NetSSHStoryHelpers
  require 'net/ssh/test'
  include Net::SSH::Test

  # FIXME: must be moved elsewhere or implemented another way/form.
  class ::Net::SSH::Test::Channel
    def gets_packet(type, *args)
      gets_data(sftp_packet(type, *args))
    end

    def sends_packet(type, *args)
      sends_data(sftp_packet(type, *args))
    end

    private

    def sftp_packet(type, *args)
      data = Net::SSH::Buffer.from(*args)
      Net::SSH::Buffer.from(:long, data.length + 1, :byte, type, :raw, data).to_s
    end
  end

  def story_with_new_channel
    story do |session|
      ch = session.opens_channel
      yield ch
      ch.gets_close
      ch.sends_close
    end
  end

  def sftp_story
    story do |session|
      ch = session.opens_channel
      ch.sends_subsystem 'sftp'
      ch.sends_packet(
        Net::SFTP::Constants::PacketTypes::FXP_INIT, :long,
        Net::SFTP::Session::HIGHEST_PROTOCOL_VERSION_SUPPORTED
      )
      ch.gets_packet(
        Net::SFTP::Constants::PacketTypes::FXP_VERSION, :long,
        Net::SFTP::Session::HIGHEST_PROTOCOL_VERSION_SUPPORTED
      )
      yield ch if block_given?
    end
  end

  def expect_story_completed
    raise 'there is no story to expect' if socket.script.events.empty?
    yield
    expect(socket.script.events)
      .to be_empty, "#{socket.script.events.count} story events still pending"
  end
end
