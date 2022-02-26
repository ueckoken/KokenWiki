class PageSearchForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :q, :string
  attribute :period, :integer, default: -1
  attribute :order, :string, default: :best_match
  attribute :target, :string, default: :content
  attribute :mode, :string, default: :natural_language
  alias_attribute :query, :q

  validates :period, inclusion: { in: [-1, 1.week, 1.month, 1.year]  }
  validates :order, inclusion: { in: %w(best_match updated_at_asc updated_at_desc) }
  validates :target, inclusion: { in: %w(content title) }
  validates :mode, inclusion: { in: %w(natural_language slower_stricter) }

  def period_duration
    return ActiveSupport::Duration.build(period)
  end
end
