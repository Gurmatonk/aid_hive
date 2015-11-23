class MailInterceptor
  DEMO_HINT = %{
    <p><strong>Diese E-Mail wurde vom Aid Hive Demo-System versendet - keine "echten" Angebote, Gesuche, Nutzerkonten oder Benachrichtigungen!</strong><br>
    <strong>This email was sent by the Aid Hive demo system - no "real" offers, requests, accounts or notifications!</strong></p>
  }
  def self.delivering_email(message)
    # Add demo system hint to every mail sent from demo environment
    message.body.raw_source.replace "#{DEMO_HINT} #{message.body.raw_source}"
  end
end

ActionMailer::Base.register_interceptor(MailInterceptor) if Rails.env.demo?
