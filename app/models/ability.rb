# frozen_string_literal: true

class Ability
  include CanCan::Ability

  ROLE_RULES = { admin: :admin_rules, librarian: :librarian_rules, member: :member_rules }.freeze
  private_constant :ROLE_RULES

  def initialize(user)
    # Define abilities for the user here. For example:
    #
    #   return unless user.present?
    #   can :read, :all
    #   return unless user.admin?
    #   can :manage, :all
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, published: true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md

    user ||= User.new(role: :member)

    public_send(ROLE_RULES[user.role.to_sym], user) if user.role.present?

    # can :read, Loan do |loan|
    #   LoanPolicy.new(user, loan).read?
    # end

    # can :create, Loan do |_loan|
    #   LoanPolicy.new(user, nil).create?
    # end

    # can :update, Loan do |loan|
    #   LoanPolicy.new(user, loan).update?
    # end

    # can :destroy, Loan do |loan|
    #   LoanPolicy.new(user, loan).destroy?
    # end
  end

  def admin_rules(_user)
    can :manage, :all
  end

  def librarian_rules(_user)
    can :manage, Book
    can :manage, Author
    can :manage, Genre
    can :manage, BookCopy

    can :read, Loan
    can :update, Loan, returned_at: nil
    cannot :destroy, Loan
  end

  def member_rules(user)
    can :read, Book
    can :read, Author
    can :read, Genre

    can :create, Loan
    can :read, Loan, user_id: user.id
    can :update, Loan, user_id: user.id, returned_at: nil
  end
end
