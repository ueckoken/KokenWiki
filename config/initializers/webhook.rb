# Webhook設定
Rails.application.config.webhook_urls = ENV.fetch('WEBHOOK_URLS', '').split(',').map(&:strip).reject(&:empty?)
Rails.application.config.enable_webhook = Rails.application.config.webhook_urls.present?