Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://redistogo:3464e7e7a1ef4619a4ec8cd100aaed21@spinyfin.redistogo.com:9882/0' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://redistogo:3464e7e7a1ef4619a4ec8cd100aaed21@spinyfin.redistogo.com:9882/0' }
end