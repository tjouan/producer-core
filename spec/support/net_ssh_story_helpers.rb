module NetSSHStoryHelpers
  require 'net/ssh/test'
  include Net::SSH::Test

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
