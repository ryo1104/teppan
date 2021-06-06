require 'tmpdir'
require 'glint'

RSpec.configure do |config|
  config.before :suite do
    rootdir = Dir.mktmpdir
    server = Glint::Server.new(nil, signals: [:INT]) do |port|
      exec "bundle exec fakes3 -p #{port} -r #{rootdir}", err: '/dev/null'
    end
    # サーバが止まったタイミングでファイルを消す
    server.on_stopped = lambda {
      FileUtils.remove_entry_secure(Glint::Server.info[:fakes3][:root]) if Dir.exist? Glint::Server.info[:fakes3][:root]
    }
    server.start

    Glint::Server.info[:fakes3] = {
      address: "127.0.0.1:#{server.port}",
      root: rootdir
    }
  end
end
