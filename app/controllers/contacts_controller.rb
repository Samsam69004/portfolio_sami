class ContactsController < ApplicationController
  def create
    # Honeypot : si le champ caché est rempli → bot
    if params[:website].present?
      flash[:_from] = "contact"
      return redirect_to(root_path(anchor: "contact"), alert: "Spam détecté.")
    end

    # Avec form_with scope:nil, les champs sont à la racine de params
    c = params.permit(:name, :email, :subject, :message)

    name    = c[:name].to_s.first(100)
    email   = c[:email].to_s.first(200)
    subject = c[:subject].to_s.first(150)
    message = c[:message].to_s.first(4000)

    unless email.match?(/\A[^@\s]+@[^@\s]+\z/) && message.present?
      flash[:_from] = "contact"
      return redirect_to(root_path(anchor: "contact"), alert: "Vérifiez l’e-mail et le message.")
    end

    ContactMailer.send_contact_email(name, email, subject, message).deliver_now

    flash[:_from] = "contact"
    redirect_to root_path(anchor: "contact"), notice: "Merci ! Votre message a bien été envoyé."
  rescue => e
    Rails.logger.error("[Contact#create] #{e.class}: #{e.message}")
    flash[:_from] = "contact"
    redirect_to root_path(anchor: "contact"), alert: "Une erreur est survenue. Réessayez plus tard."
  end
end
