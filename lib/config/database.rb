# Copyright (c) 2025 kk
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

require 'sqlite3'
require 'bcrypt'

module Config
  class Database
    def self.get_db_path
      ENV['DATABASE_PATH'] || 'knav.db'
    end

    def self.init_db
      db_path = get_db_path

      # 确保数据目录存在
      db_dir = File.dirname(db_path)
      Dir.mkdir(db_dir) unless Dir.exist?(db_dir)

      db = SQLite3::Database.new db_path

      # Create categories table
      db.execute <<-SQL
        CREATE TABLE IF NOT EXISTS categories (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          description TEXT,
          sort_order INTEGER DEFAULT 0,
          created_at DATETIME DEFAULT CURRENT_TIMESTAMP
        );
      SQL

      # Create navigation links table
      db.execute <<-SQL
        CREATE TABLE IF NOT EXISTS nav_links (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          url TEXT NOT NULL,
          description TEXT,
          category_id INTEGER,
          icon TEXT,
          sort_order INTEGER DEFAULT 0,
          is_active BOOLEAN DEFAULT 1,
          created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (category_id) REFERENCES categories (id)
        );
      SQL

      # Create admin users table
      db.execute <<-SQL
        CREATE TABLE IF NOT EXISTS admin_users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT UNIQUE NOT NULL,
          password_hash TEXT NOT NULL,
          created_at DATETIME DEFAULT CURRENT_TIMESTAMP
        );
      SQL

      # Create default admin user (username: admin, password: admin123)
      password_hash = BCrypt::Password.create('admin123')
      db.execute 'INSERT OR IGNORE INTO admin_users (username, password_hash) VALUES (?, ?)',
                 ['admin', password_hash]

      # Insert sample data if tables are empty
      category_count = db.execute('SELECT COUNT(*) FROM categories')[0][0]
      if category_count == 0
        # Sample categories
        db.execute 'INSERT INTO categories (name, description, sort_order) VALUES (?, ?, ?)',
                   ['监控系统', '各种监控和告警系统', 1]
        db.execute 'INSERT INTO categories (name, description, sort_order) VALUES (?, ?, ?)',
                   ['日志系统', '日志收集和分析系统', 2]
        db.execute 'INSERT INTO categories (name, description, sort_order) VALUES (?, ?, ?)',
                   ['容器管理', 'Docker和Kubernetes管理', 3]
        db.execute 'INSERT INTO categories (name, description, sort_order) VALUES (?, ?, ?)',
                   ['CI/CD', '持续集成和部署工具', 4]

        # Sample navigation links
        db.execute 'INSERT INTO nav_links (title, url, description, category_id, icon, sort_order, is_active) VALUES (?, ?, ?, ?, ?, ?, ?)',
                   ['Prometheus', 'http://prometheus.example.com', '监控数据收集和存储', 1, '🌐', 1, 1]
        db.execute 'INSERT INTO nav_links (title, url, description, category_id, icon, sort_order, is_active) VALUES (?, ?, ?, ?, ?, ?, ?)',
                   ['Grafana', 'http://grafana.example.com', '数据可视化仪表板', 1, '🌐', 2, 1]
        db.execute 'INSERT INTO nav_links (title, url, description, category_id, icon, sort_order, is_active) VALUES (?, ?, ?, ?, ?, ?, ?)',
                   ['ELK Stack', 'http://elasticsearch.example.com', '日志搜索和分析', 2, '🌐', 1, 1]
        db.execute 'INSERT INTO nav_links (title, url, description, category_id, icon, sort_order, is_active) VALUES (?, ?, ?, ?, ?, ?, ?)',
                   ['Docker Registry', 'http://registry.example.com', '容器镜像仓库', 3, '🌐', 1, 1]
        db.execute 'INSERT INTO nav_links (title, url, description, category_id, icon, sort_order, is_active) VALUES (?, ?, ?, ?, ?, ?, ?)',
                   ['Jenkins', 'http://jenkins.example.com', '自动化构建和部署', 4, '🌐', 1, 1]
      end

      db.close
    end

    def self.get_db
      SQLite3::Database.new get_db_path
    end
  end
end
