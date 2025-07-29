# Copyright (c) 2025 kk
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

require 'json'
require_relative '../models/admin_user'
require_relative '../models/category'
require_relative '../models/nav_link'
require_relative '../helpers/auth_helper'
require_relative '../helpers/url_helper'

module Controllers
  class AdminController
    include Helpers::AuthHelper
    include Helpers::UrlHelper

    def self.login(username, password)
      result = Models::AdminUser.authenticate(username, password)

      if result[:success]
        { success: true, username: result[:username] }
      else
        { success: false, error: '用户名或密码错误' }
      end
    end

    def self.change_password(username, current_password, new_password, confirm_password)
      # Validate input
      return { success: false, error: '请输入当前密码' } if current_password.nil? || current_password.empty?

      return { success: false, error: '请输入新密码' } if new_password.nil? || new_password.empty?

      return { success: false, error: '新密码长度至少6位' } if new_password.length < 6

      return { success: false, error: '两次输入的新密码不一致' } if new_password != confirm_password

      # Verify current password
      user = Models::AdminUser.find_by_username(username)
      if user.nil? || !BCrypt::Password.new(user[2]).is_password?(current_password)
        return { success: false, error: '当前密码错误' }
      end

      # Update password
      Models::AdminUser.update_password(username, new_password)
      { success: true, message: '密码修改成功！' }
    end

    def self.create_category(name, description, sort_order)
      Models::Category.create(name, description, sort_order)
      { success: true }
    rescue StandardError => e
      { success: false, error: e.message }
    end

    def self.update_category(id, name, description, sort_order)
      Models::Category.update(id, name, description, sort_order)
      { success: true }
    rescue StandardError => e
      { success: false, error: e.message }
    end

    def self.delete_category(id)
      Models::Category.delete(id)
      { success: true }
    rescue StandardError => e
      { success: false, error: e.message }
    end

    def self.create_link(title, url, description, category_id, icon, sort_order, is_active)
      Models::NavLink.create(title, url, description, category_id, icon, sort_order, is_active)
      { success: true }
    rescue StandardError => e
      { success: false, error: e.message }
    end

    def self.update_link(id, title, url, description, category_id, icon, sort_order, is_active)
      Models::NavLink.update(id, title, url, description, category_id, icon, sort_order, is_active)
      { success: true }
    rescue StandardError => e
      { success: false, error: e.message }
    end

    def self.delete_link(id)
      Models::NavLink.delete(id)
      { success: true }
    rescue StandardError => e
      { success: false, error: e.message }
    end

    def self.toggle_link_active(id, is_active)
      Models::NavLink.toggle_active(id, is_active)
      { success: true, is_active: is_active }
    rescue StandardError => e
      { success: false, error: e.message }
    end
  end
end
