
url = ENV["REDISTOGO_URL"] || "redis://localhost:6379/"
REDIS = Redis.new(url: url)

servers = (ENV["MEMCACHIER_SERVERS"] || "localhost:11211").split(",")
options = {
  :username => ENV["MEMCACHIER_USERNAME"],
  :password => ENV["MEMCACHIER_PASSWORD"],
  :failover => true,
  :socket_timeout => 1.5,
  :socket_failure_delay => 0.2,
  compress: true
}
MEMCACHED = ConnectionPool.new(size: 5, timeout: 5) { Dalli::Client.new(servers, options) }