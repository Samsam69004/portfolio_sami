# app/mailers/contact_mailer.rb
class ContactMailer < ApplicationMailer
  default to: "chabanesami7@gmail.com"

  def send_contact_email(name, email, subject, message)
    @name = name
    @from_email = email
    @message = message
    mail(from: email, subject: subject.presence || "Nouveau message (portfolio)")
  end
end
