if ENV["REDIS_URL"]
    uri = URI.parse(ENV["REDIS_URL"])
    $redis = Redis.new(:host => uri.host)
end
