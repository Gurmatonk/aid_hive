class EntryPolicy
  attr_reader :current_user, :entry

  def initialize(current_user, model)
    @current_user = current_user
    @entry = model
  end

  def create?
    new? && entry.user == current_user
  end

  def complete?
    owner_or_admin? && entry.may_complete?
  end

  def destroy?
    owner_or_admin?
  end

  def edit?
    owner_or_admin?
  end

  def index?
    true
  end

  def my?
    current_user.present?
  end

  def new?
    current_user.present?
  end

  def show?
    entry.present?
  end

  def update?
    edit?
  end

  def permitted_attributes
    [:city, :description, :postal_code, :street_name, :street_number, :title]
  end

  private

  def owner_or_admin?
    entry.user == current_user || current_user.try(:admin?)
  end
end
