class WebhookJob < ApplicationJob
  require 'net/http'
  require 'uri'
  require 'json'
  include Rails.application.routes.url_helpers

  def perform(page_id, user_id_updated)
    begin
      page = Page.find(page_id)
      user_updated = User.find(user_id_updated)

      Rails.logger.info "Page #{page.title} was updated by #{user_updated.name}. Webhook will be triggered."
      
      webhook_urls = Rails.application.config.webhook_urls || []
      
      # アプリケーションのホスト設定を取得
      host = Rails.application.config.action_mailer&.default_url_options&.dig(:host) ||
             'localhost:3000'
      
      # プロトコル設定を取得（デフォルトはhttps）
      protocol = Rails.application.config.action_mailer&.default_url_options&.dig(:protocol) ||
                 'https'
      
      # ポート設定を取得（あれば）
      port = Rails.application.config.action_mailer&.default_url_options&.dig(:port)
      
      # Pageのpathメソッドを使ってページのパスを取得し、完全なURLを生成
      page_url = if port
                   "#{protocol}://#{host}:#{port}#{page.path}"
                 else
                   "#{protocol}://#{host}#{page.path}"
                 end
      
      webhook_urls.each do |url|
        payload = {
          "content": "#{user_updated.name} さんが [#{page.path}](#{page_url}) を更新しました。"
        }
        
        begin
          uri = URI.parse(url)
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = (uri.scheme == 'https')
          request = Net::HTTP::Post.new(uri.request_uri, {'Content-Type' => 'application/json'})
          request.body = payload.to_json
          response = http.request(request)
          Rails.logger.info "次のWebhookに送信しました: #{url}"
        rescue => e
          Rails.logger.error "Webhook送信エラー(#{url}): #{e.message}"
        end
      end
    rescue => e
      Rails.logger.error "Webhook処理エラー: #{e.message}"
    end
  end
end 