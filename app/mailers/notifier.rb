class Notifier < ActionMailer::Base
  default :from => " GreatWar1418 litehouse.dev@gmail.com"
    
  def support_notification(sender)
    @sender = sender
    mail(:to => "litehouse.dev@gmail.com",
        :from => sender.email,
        :subject => "New #{sender.support_type}")
  end

end
