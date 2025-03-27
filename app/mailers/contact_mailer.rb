class ContactMailer < ApplicationMailer
  def contact_email(name, email, subject, message)
    @name = name
    @email = email
    @subject = subject
    @message = message

    mail(
      to: "contact@emportet.fr",
      subject: "[Contact] #{subject}"
    )
  end
end
