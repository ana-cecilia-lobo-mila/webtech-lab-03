class MechanicPolicy < ApplicationPolicy
  def index?
    user&.owner? || user&.counter? || user&.mechanic?
  end

  def show?
    index?
  end

  def create?
    user&.owner?
  end

  def update?
    user&.owner?
  end

  def destroy?
    user&.owner?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.all if user&.owner? || user&.counter? || user&.mechanic?

      scope.none
    end
  end
end
