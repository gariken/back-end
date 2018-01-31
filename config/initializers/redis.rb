REDIS_HOST = ENV.fetch("REDIS_HOST") { "127.0.0.1" }
REDIS_PORT = ENV.fetch("REDIS_PORT") { 6379 }
REDIS_DB_INDEX = ENV.fetch("REDIS_DB_INDEX") { 9 }

Redis.current = begin
  if ENV["ASSET_HOST"].include? "heroku"
    Redis.new(url: ENV["REDIS_URL"], db: 0)
  else
    Redis.new(host: REDIS_HOST, port: REDIS_PORT, db: REDIS_DB_INDEX)
  end
rescue StandardError
  Redis.new(host: "127.0.0.1", port: 6379, db: REDIS_DB_INDEX)
end
