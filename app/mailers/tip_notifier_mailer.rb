class TipNotifierMailer < ApplicationMailer
  default from: 'notification@new.tip'

  def tip_notifications_mail(tip)
    @tip = tip
    recipients = []
    @tip.user.followers.each do |u|
      unless u.email.nil? or u.email.blank?
        recipients << u.email
      end
    end
    mail to: recipients, subject: "New tip notification"
  end
end
