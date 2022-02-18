bind "tcp://#{ENV.fetch('INTERFACE', '127.0.0.1')}:#{ENV.fetch('PORT', 3000)}"
