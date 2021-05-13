class NotificationMailer < ApplicationMailer
  def notify
    @user = params[:user]
    @notification = params[:notification]

    mail to: @user.email,
         subject: 'Orcheya\'s notificator',
         template_name: 'common'
  end
end
