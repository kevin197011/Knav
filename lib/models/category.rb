# Copyright (c) 2025 kk
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

require_relative '../config/database'

module Models
  class Category
    def self.all
      db = Config::Database.get_db
      categories = db.execute('SELECT * FROM categories ORDER BY sort_order, name')
      db.close
      categories
    end

    def self.find(id)
      db = Config::Database.get_db
      category = db.execute('SELECT * FROM categories WHERE id = ?', [id]).first
      db.close
      category
    end

    def self.create(name, description, sort_order = 0)
      db = Config::Database.get_db
      db.execute('INSERT INTO categories (name, description, sort_order) VALUES (?, ?, ?)',
                 [name, description, sort_order])
      db.close
    end

    def self.update(id, name, description, sort_order)
      db = Config::Database.get_db
      db.execute('UPDATE categories SET name = ?, description = ?, sort_order = ? WHERE id = ?',
                 [name, description, sort_order, id])
      db.close
    end

    def self.delete(id)
      db = Config::Database.get_db
      db.execute('DELETE FROM categories WHERE id = ?', [id])
      db.execute('DELETE FROM nav_links WHERE category_id = ?', [id])
      db.close
    end

    def self.with_links
      db = Config::Database.get_db
      categories = db.execute('SELECT * FROM categories ORDER BY sort_order, name')
      result = categories.map do |category|
        links = db.execute(
          'SELECT * FROM nav_links WHERE category_id = ? AND is_active = 1 ORDER BY sort_order, title', [category[0]]
        )
        {
          id: category[0],
          name: category[1],
          description: category[2],
          sort_order: category[3],
          links: links.map do |link|
            {
              id: link[0],
              title: link[1],
              url: link[2],
              description: link[3],
              icon: link[5],
              sort_order: link[6]
            }
          end
        }
      end
      db.close
      result
    end
  end
end
