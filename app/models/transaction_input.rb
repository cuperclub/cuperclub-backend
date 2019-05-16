# == Schema Information
#
# Table name: transaction_inputs
#
#  id             :bigint(8)        not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint(8)
#  employee_id    :bigint(8)
#  points         :float
#  invoice_number :string
#

class TransactionInput < ApplicationRecord

  begin :relationships
    belongs_to :user
    belongs_to :employee
  end

  begin :validations
    validate :cannot_assign_yourself
  end

  begin :callbacks
    after_create :update_user_points
  end

  def update_user_points
    user.points = user.points + points
    user.save
  end

  def cannot_assign_yourself
    if user == employee.user
      errors.add(:user, "cannot assign yourself")
    end
  end

end
