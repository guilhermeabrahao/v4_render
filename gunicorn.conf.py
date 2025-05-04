import multiprocessing
import os

# Gunicorn configuration for production

# Worker configuration
workers = multiprocessing.cpu_count() * 2 + 1
threads = 2
worker_class = 'gthread'
worker_connections = 1000

# Timeouts
timeout = 120
keepalive = 5

# Logging
accesslog = '-'
errorlog = '-'
loglevel = 'info'

# Bind
bind = f"0.0.0.0:{int(os.getenv('PORT', 5000))}"

# Security
limit_request_line = 4094
limit_request_fields = 100
limit_request_field_size = 8190
