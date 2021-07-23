module UriHelper
  def is_external_uri?(uri_string)
    uri = URI.parse(uri_string)
    return uri.absolute?
  rescue URI::InvalidURIError
    return false
  rescue URI::InvalidComponentError
    return false
  end
end
