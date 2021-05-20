class WalletPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end

  def create?
    true
  end

  def show?
    update?
  end

  def update?
    user == record.user
  end
end
