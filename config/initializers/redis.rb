
url = ENV["REDISTOGO_URL"] || "redis://localhost:6379/"
REDIS = Redis.new(url: url)

servers = (ENV["MEMCACHIER_SERVERS"] || "localhost:11211").split(",")
MEMCACHED = ConnectionPool.new(size: 5, timeout: 5) { Dalli::Client.new(servers, { compress: true }) }