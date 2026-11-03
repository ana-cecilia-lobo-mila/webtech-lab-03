class RepairPolicy < ApplicationPolicy
  def index?
    user&.owner? || user&.counter? || user&.mechanic?
  end

  def show?
    return true if user&.owner? || user&.counter?

    assigned_to_user?
  end

  def create?
    user&.owner? || user&.counter?
  end

  def update?
    return true if user&.owner?
    return !record.picked_up? if user&.counter?

    user&.mechanic? && assigned_to_user? && !record.picked_up?
  end

  def destroy?
    user&.owner?
  end

  def destroy_intake_photo?
    return true if user&.owner?

    user&.counter? && !record.picked_up?
  end

  def permitted_attributes
    if user&.owner? || user&.counter?
      [
        :bike_id,
        :mechanic_id,
        :promised_on,
        :started_on,
        :state,
        :diagnosis,
        {
          intake_photos: [],
          repair_services_attributes: [
            [:id, :service_id, :charged_price, :_destroy]
          ]
        }
      ]
    elsif user&.mechanic? && assigned_to_user? && !record.picked_up?
      [:state, :diagnosis, { intake_photos: [] }]
    else
      []
    end
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.all if user&.owner? || user&.counter?

      if user&.mechanic? && user.mechanic_id.present?
        return scope.where(mechanic_id: user.mechanic_id)
      end

      scope.none
    end
  end

  private

  def assigned_to_user?
    user&.mechanic? &&
      user.mechanic_id.present? &&
      record.mechanic_id == user.mechanic_id
  end
end
