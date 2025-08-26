# app/mailers/contact_mailer.rb
class ContactMailer < ApplicationMailer
  default to: "chabanesami7@gmail.com"

  def send_contact_email(name, from_email, subject, message)
    @name = name
    @from_email = from_email
    @message = message

    mail(
      from: Rails.application.credentials.dig(:gmail, :user), # ton Gmail
      reply_to: from_email,                                   # l'adresse du visiteur
      subject: subject.presence || "Nouveau message (portfolio)"
    )
  end
end
