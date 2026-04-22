# frozen_string_literal: true

class LoanPolicy
  attr_reader :user, :loan

  def initialize(user, loan)
    @user = user
    @loan = loan
  end

  def read?
    admin? || librarian? || owns_loan?
  end

  def create?
    member? || admin? || librarian?
  end

  def update?
    return false if loan.returned_at.present?

    admin? ||
      librarian? ||
      (member? && owns_loan?)
  end

  def destroy?
    admin?
  end

  private

  def owns_loan?
    loan.user_id == user.id
  end

  def admin?
    user.admin?
  end

  def librarian?
    user.librarian?
  end

  def member?
    user.member?
  end
end
