
url = ENV["REDISTOGO_URL"] || "redis://localhost:6379/"
REDIS = Redis.new(url: url)

MEMCACHED = ConnectionPool.new(size: 5, timeout: 5) { Dalli::Client.new('localhost:11211', { compress: true }) }