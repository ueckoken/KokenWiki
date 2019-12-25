class UpdateRootPagePath < ActiveRecord::Migration[6.0]
  def change
    root_page = Page.find_by(path: "")
    if root_page.nil?
      return
    end
    root_page.update(
      path: "/"
    )
  end
end
