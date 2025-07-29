# Copyright (c) 2025 kk
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

require_relative '../config/database'

module Models
  class NavLink
    def self.all_with_pagination(page = 1, per_page = 10, category_filter = nil)
      db = Config::Database.get_db

      # 确保页码有效
      page = 1 if page < 1
      per_page = 10 if per_page < 1 || per_page > 100

      # 构建查询条件
      where_clause = ''
      query_params = []

      if category_filter && !category_filter.empty?
        where_clause = 'WHERE c.name = ?'
        query_params << category_filter
      end

      # 获取总数
      count_sql = <<-SQL
        SELECT COUNT(*)
        FROM nav_links nl
        LEFT JOIN categories c ON nl.category_id = c.id
        #{where_clause}
      SQL
      total_count = db.execute(count_sql, query_params)[0][0]

      # 计算分页信息
      total_pages = (total_count.to_f / per_page).ceil
      total_pages = 1 if total_pages < 1
      page = total_pages if page > total_pages

      offset = (page - 1) * per_page

      # 获取当前页数据
      links_sql = <<-SQL
        SELECT nl.*, c.name as category_name
        FROM nav_links nl
        LEFT JOIN categories c ON nl.category_id = c.id
        #{where_clause}
        ORDER BY nl.sort_order, nl.title
        LIMIT ? OFFSET ?
      SQL
      links = db.execute(links_sql, query_params + [per_page, offset])

      # 分页信息
      pagination = {
        current_page: page,
        per_page: per_page,
        total_count: total_count,
        total_pages: total_pages,
        has_prev: page > 1,
        has_next: page < total_pages,
        prev_page: page > 1 ? page - 1 : nil,
        next_page: page < total_pages ? page + 1 : nil,
        category_filter: category_filter
      }

      db.close
      { links: links, pagination: pagination }
    end

    def self.create(title, url, description, category_id, icon, sort_order = 0, is_active = 1)
      db = Config::Database.get_db
      db.execute('INSERT INTO nav_links (title, url, description, category_id, icon, sort_order, is_active) VALUES (?, ?, ?, ?, ?, ?, ?)',
                 [title, url, description, category_id, icon, sort_order, is_active])
      db.close
    end

    def self.update(id, title, url, description, category_id, icon, sort_order, is_active)
      db = Config::Database.get_db
      db.execute('UPDATE nav_links SET title = ?, url = ?, description = ?, category_id = ?, icon = ?, sort_order = ?, is_active = ? WHERE id = ?',
                 [title, url, description, category_id, icon, sort_order, is_active, id])
      db.close
    end

    def self.delete(id)
      db = Config::Database.get_db
      db.execute('DELETE FROM nav_links WHERE id = ?', [id])
      db.close
    end

    def self.find_by_id(id)
      db = Config::Database.get_db
      result = db.execute('SELECT * FROM nav_links WHERE id = ?', [id])
      db.close
      result.first
    end

    def self.toggle_active(id, is_active)
      db = Config::Database.get_db
      db.execute('UPDATE nav_links SET is_active = ? WHERE id = ?', [is_active, id])
      db.close
      is_active
    end

    def self.search_suggestions(query, limit = 10)
      return { suggestions: [] } if query.nil? || query.strip.length < 1

      query = query.strip.downcase
      db = Config::Database.get_db

      # 搜索链接标题、描述和分类名称
      search_sql = <<-SQL
        SELECT DISTINCT
          nl.title,
          nl.description,
          c.name as category_name,
          nl.url,
          nl.icon,
          'link' as type,
          CASE
            WHEN LOWER(nl.title) LIKE ? THEN 1
            ELSE 3
          END as priority
        FROM nav_links nl
        LEFT JOIN categories c ON nl.category_id = c.id
        WHERE nl.is_active = 1
          AND (
            LOWER(nl.title) LIKE ? OR
            LOWER(nl.description) LIKE ? OR
            LOWER(c.name) LIKE ?
          )

        UNION

        SELECT DISTINCT
          c.name as title,
          c.description,
          c.name as category_name,
          '' as url,
          '📁' as icon,
          'category' as type,
          CASE
            WHEN LOWER(c.name) LIKE ? THEN 2
            ELSE 4
          END as priority
        FROM categories c
        WHERE EXISTS (
          SELECT 1 FROM nav_links nl
          WHERE nl.category_id = c.id AND nl.is_active = 1
        )
        AND LOWER(c.name) LIKE ?

        ORDER BY priority, title
        LIMIT ?
      SQL

      like_query = "%#{query}%"
      starts_with_query = "#{query}%"

      results = db.execute(search_sql, [
                             starts_with_query, # 第一个SELECT的优先级判断
                             like_query, like_query, like_query,  # 第一个SELECT的WHERE条件
                             starts_with_query,                   # 第二个SELECT的优先级判断
                             like_query,                          # 第二个SELECT的WHERE条件
                             limit
                           ])

      suggestions = results.map do |row|
        {
          title: row[0],
          description: row[1] || '',
          category: row[2] || '',
          url: row[3] || '',
          icon: row[4] || '🔗',
          type: row[5]
        }
      end

      db.close
      { suggestions: suggestions }
    end
  end
end
