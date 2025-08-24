class ContactsController < ApplicationController
  def new
  end

  def create
    return redirect_to contact_path, alert: "Erreur." if params[:website].present? # honeypot

    name    = params[:name].to_s.first(100)
    email   = params[:email].to_s.first(200)
    subject = params[:subject].to_s.first(150)
    message = params[:message].to_s.first(4000)

    unless email.match?(/\A[^@\s]+@[^@\s]+\z/) && message.present?
      return redirect_to contact_path, alert: "Vérifiez l’email et le message."
    end

    ContactMailer.send_contact_email(name, email, subject, message).deliver_now
    redirect_to contact_path, notice: "Merci ! Votre message a bien été envoyé."
  rescue => e
    Rails.logger.error("Contact error: #{e.class} #{e.message}")
    redirect_to contact_path, alert: "Une erreur est survenue. Réessayez plus tard."
  end
end
