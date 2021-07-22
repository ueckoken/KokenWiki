module UriHelper
  def is_uri?(url)
    URI.parse(url)
    return true
  rescue URI::InvalidURIError
    return false
  rescue URI::InvalidComponentError
    return false
  end
end
