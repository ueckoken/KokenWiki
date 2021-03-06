module PathHelper
  # "/" -> "/"
  # "a/b" -> "/a/b"
  # "a/b/"-> "/a/b"
  def get_formal_pathname(path)
    if path.nil?
      return Pathname.new("/")
    end
    return Pathname.new(params[:pages]).expand_path("/").cleanpath
  end

  def get_title(pathname)
    if is_root_path?(pathname)
      return ""
    end
    return pathname.basename
  end

  def is_root_path?(pathname)
    return pathname.root?
  end
end
