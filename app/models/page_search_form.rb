class PageSearchForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :q, :string
  attribute :period, :integer, default: -1
  attribute :order, :string, default: :best_match
  attribute :target, :string, default: :content
  alias_attribute :query, :q

  validates :period, inclusion: { in: [-1, 1.week, 1.month, 1.year]  }
  validates :order, inclusion: { in: %w(best_match updated_at_asc updated_at_desc) }
  validates :target, inclusion: { in: %w(content title) }

  def period_duration
    return ActiveSupport::Duration.build(period)
  end
end
