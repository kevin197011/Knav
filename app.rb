# Copyright (c) 2025 kk
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

require 'sinatra'
require 'json'
require 'rack/session/cookie'

# Load all modules
require_relative 'lib/config/database'
require_relative 'lib/helpers/auth_helper'
require_relative 'lib/helpers/url_helper'
require_relative 'lib/models/category'
require_relative 'lib/models/nav_link'
require_relative 'lib/models/admin_user'
require_relative 'lib/controllers/admin_controller'
require_relative 'lib/controllers/api_controller'

# Load all routes
require_relative 'lib/routes/main_routes'
require_relative 'lib/routes/admin_routes'
require_relative 'lib/routes/category_routes'
require_relative 'lib/routes/link_routes'
require_relative 'lib/routes/api_routes'

# Configure the application
configure do
  enable :sessions
  set :session_secret,
      ENV['SESSION_SECRET'] || 'a_very_long_random_string_that_is_at_least_32_bytes_long_for_session_security'
  set :public_folder, 'public'
  set :views, 'lib/views'

  # Ensure sessions work with AJAX requests
  use Rack::Session::Cookie,
      key: 'rack.session',
      path: '/',
      expire_after: 2_592_000, # 30 days
      secret: ENV['SESSION_SECRET'] || 'a_very_long_random_string_that_is_at_least_32_bytes_long_for_session_security',
      httponly: true,
      same_site: :lax
end

# Include helpers
include Helpers::AuthHelper
include Helpers::UrlHelper

# Initialize database
Config::Database.init_db

# Mount all routes
use Routes::MainRoutes
use Routes::AdminRoutes
use Routes::CategoryRoutes
use Routes::LinkRoutes
use Routes::ApiRoutes
