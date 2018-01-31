# Rails.application.config.session_store :redis_store, {
#   servers: [
#     {
#       host: ENV.fetch("REDIS_HOST") { "127.0.0.1" },
#       port: ENV.fetch("REDIS_PORT") { 6379 },
#       db: 0,
#       namespace: "session"
#     },
#   ],
#   expire_after: 480.minutes,
#   key_prefix: '_taxi_session'
# }
