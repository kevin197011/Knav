# Copyright (c) 2025 kk
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

module Helpers
  module AuthHelper
    def require_admin
      redirect '/admin/login' unless session[:admin_logged_in]
    end
  end
end
