# frozen_string_literal: true

# Copyright (c) 2025 kk
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

require 'time'

# task default: %w[push]

task :push do
  system 'git add .'
  system "git commit -m 'Update #{Time.now}'"
  system 'git pull'
  system 'git push origin main'
end

task :dev do
  system 'export COMPOSE_BAKE=true'
  system 'docker compose up --build -d'
  system 'docker compose logs -f'
end
