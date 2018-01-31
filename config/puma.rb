threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }.to_i
threads 1, threads_count

port        ENV.fetch("PORT") { 3000 }
environment ENV.fetch("RAILS_ENV") { 'development' }

workers ENV.fetch("WEB_CONCURRENCY") { 2 }

preload_app! if ENV["RAILS_ENV"] == 'production'

on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end

before_fork do
  ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
end

plugin :tmp_restart
