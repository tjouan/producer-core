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

  def expect_story_completed
    raise 'there is no story to expect' if socket.script.events.empty?
    yield
    expect(socket.script.events)
      .to be_empty, "#{socket.script.events.count} story events still pending"
  end
end
