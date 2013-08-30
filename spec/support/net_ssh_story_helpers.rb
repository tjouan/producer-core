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

  def story_completed?
    socket.script.events.empty?
  end
end
