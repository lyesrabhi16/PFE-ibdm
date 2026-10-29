"""Embed the IBDM logo in e-mails as an inline image (`<img src="cid:ibdm_logo">`).

Embedding works offline and on private networks, unlike linking to an image hosted on a CDN.
"""
from email.mime.image import MIMEImage
from pathlib import Path

from django.conf import settings

LOGO_CID = "ibdm_logo"
LOGO_PATH = Path(settings.BASE_DIR) / "templates" / "emails" / "logo.png"


def attach_logo(message):
    """Attach the logo to an EmailMessage so templates can reference it as cid:ibdm_logo."""
    message.mixed_subtype = "related"
    image = MIMEImage(LOGO_PATH.read_bytes(), _subtype="png")
    image.add_header("Content-ID", f"<{LOGO_CID}>")
    image.add_header("Content-Disposition", "inline", filename="logo.png")
    message.attach(image)


def send_mail_with_logo(subject, message, html_message, from_email, recipient_list, connection=None):
    """Same arguments as django.core.mail.send_mail(html_message=...), plus the inline logo."""
    from django.core.mail import EmailMultiAlternatives

    email = EmailMultiAlternatives(subject, message, from_email, recipient_list, connection=connection)
    email.attach_alternative(html_message, "text/html")
    attach_logo(email)
    return email.send()
