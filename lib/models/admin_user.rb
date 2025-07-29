# Copyright (c) 2025 kk
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

require 'bcrypt'
require_relative '../config/database'

module Models
  class AdminUser
    def self.authenticate(username, password)
      db = Config::Database.get_db
      user = db.execute('SELECT * FROM admin_users WHERE username = ?', [username]).first
      db.close

      if user && BCrypt::Password.new(user[2]) == password
        { success: true, username: user[1] }
      else
        { success: false }
      end
    end

    def self.find_by_username(username)
      db = Config::Database.get_db
      user = db.execute('SELECT * FROM admin_users WHERE username = ?', [username]).first
      db.close
      user
    end

    def self.update_password(username, new_password)
      db = Config::Database.get_db
      new_password_hash = BCrypt::Password.create(new_password)
      db.execute('UPDATE admin_users SET password_hash = ? WHERE username = ?',
                 [new_password_hash, username])
      db.close
    end
  end
end
