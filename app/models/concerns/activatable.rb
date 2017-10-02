module Activatable
  extend ActiveSupport::Concern

  included do
    # Scopes
    scope :active, -> {where(enabled: true)}
    scope :inactive, -> {where(enabled: false)}
  end

  def destroy
    update(enabled: false)
  end
end