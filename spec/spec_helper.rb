require 'bundler/setup'
Bundler.setup
require 'faraday'
require 'wss_agent'
require 'webmock/rspec'
require 'timecop'


RSpec.configure do |config|

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  def capture(stream)
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end
    result
  end

end
