module TimeElementsHelper
  # Returns an relative-time tag for the givin date or time
  def relative_time_tag(date_or_time, *args, &block)
    any_time_tag("relative-time", date_or_time, *args, &block)
  end
end
