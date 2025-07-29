# Copyright (c) 2025 kk
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

module Helpers
  module UrlHelper
    def build_pagination_url(page, per_page = nil, category = nil)
      # 使用当前参数作为默认值
      per_page ||= params[:per_page] || 10
      category ||= params[:category]

      url = "/admin/links?page=#{page}&per_page=#{per_page}"
      url += "&category=#{category}" if category && !category.empty?
      url
    end

    # 获取当前请求的基础URL，自动适配端口
    def get_base_url
      scheme = request.scheme
      host = request.host
      port = request.port

      # 如果是标准端口，不显示端口号
      if (scheme == 'http' && port == 80) || (scheme == 'https' && port == 443)
        "#{scheme}://#{host}"
      else
        "#{scheme}://#{host}:#{port}"
      end
    end
  end
end
