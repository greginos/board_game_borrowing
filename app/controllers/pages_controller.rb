class PagesController < ApplicationController
  def legal
  end

  def contact
    if request.post?
      ContactMailer.contact_email(
        params[:name],
        params[:email],
        params[:subject],
        params[:message]
      ).deliver_now

      flash[:notice] = "Votre message a été envoyé avec succès."
      redirect_to legal_path
    end
  end
end
