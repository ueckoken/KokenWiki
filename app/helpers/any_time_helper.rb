module AnyTimeHelper
  # Returns an HTML time-like tag for the givin date or time
  # mostly based on Rails `time_tag`
  # ref: https://github.com/rails/rails/blob/v6.1.5/actionview/lib/action_view/helpers/date_helper.rb
  def any_time_tag(tag_name, date_or_time, *args, &block)
    options  = args.extract_options!
    format   = options.delete(:format) || :long
    content  = args.first || I18n.l(date_or_time, format: format)

    content_tag(tag_name, content, options.reverse_merge(datetime: date_or_time.iso8601), &block)
  end
end
