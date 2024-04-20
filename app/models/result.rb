class Result < ApplicationRecord
  belongs_to :page

  # functions send the email notification
  def notify
    return unless success?
    UserMailer.with(result: self).success.deliver_later
  end
end
