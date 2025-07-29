# Copyright (c) 2025 kk
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

require 'sinatra/base'

module Routes
  class AdminRoutes < Sinatra::Base
    set :views, File.join(File.dirname(__FILE__), '..', 'views')
    helpers Helpers::AuthHelper
    helpers Helpers::UrlHelper

    get '/admin' do
      require_admin
      redirect '/admin/dashboard'
    end

    get '/admin/login' do
      @base_url = get_base_url
      erb :admin_login, layout: :admin_layout
    end

    post '/admin/login' do
      username = params[:username]
      password = params[:password]

      result = Controllers::AdminController.login(username, password)

      if result[:success]
        session[:admin_logged_in] = true
        session[:admin_username] = result[:username]
        redirect '/admin/dashboard'
      else
        @error = result[:error]
        @base_url = get_base_url
        erb :admin_login, layout: :admin_layout
      end
    end

    get '/admin/logout' do
      session[:admin_logged_in] = nil
      session[:admin_username] = nil
      redirect '/admin/login'
    end

    get '/admin/dashboard' do
      require_admin
      @categories = Models::Category.with_links
      @base_url = get_base_url
      erb :admin_dashboard, layout: :admin_layout
    end

    get '/admin/change_password' do
      require_admin
      @base_url = get_base_url
      erb :admin_change_password, layout: :admin_layout
    end

    post '/admin/change_password' do
      require_admin
      current_password = params[:current_password]
      new_password = params[:new_password]
      confirm_password = params[:confirm_password]

      result = Controllers::AdminController.change_password(session[:admin_username], current_password, new_password,
                                                            confirm_password)

      if result[:success]
        session[:admin_logged_in] = nil # Force re-login after password change
        session[:admin_username] = nil
        @success = '密码修改成功，请重新登录。'
        @base_url = get_base_url
        erb :admin_login, layout: :admin_layout
      else
        @error = result[:error]
        @base_url = get_base_url
        erb :admin_change_password, layout: :admin_layout
      end
    end
  end
end
