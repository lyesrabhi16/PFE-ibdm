from django.contrib import admin

from emails.models import EmailSchedule, sentEmail, AlertEmail

# Register your models here.
admin.site.register(EmailSchedule)
admin.site.register(sentEmail)
admin.site.register(AlertEmail)