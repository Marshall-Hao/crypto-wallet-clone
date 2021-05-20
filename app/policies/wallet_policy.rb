class WalletPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin
        scope.all
      else
        scope.where(user: user)
      end
    end
  end

  def create?
    true
  end

  def show?
    update? || user.admin
  end

  def update?
    user == record.user
  end
end
