class CustomerPolicy < ApplicationPolicy
  def index?
    user&.owner? || user&.counter?
  end

  def show?
    index?
  end

  def create?
    index?
  end

  def update?
    index?
  end

  def destroy?
    user&.owner?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.all if user&.owner? || user&.counter?

      scope.none
    end
  end
end
