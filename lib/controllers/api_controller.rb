# Copyright (c) 2025 kk
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

require_relative '../models/nav_link'

module Controllers
  class ApiController
    def self.search_suggestions(query, limit = 10)
      Models::NavLink.search_suggestions(query, limit)
    end
  end
end
