from django.contrib import admin

from emails.models import EmailSchedule, AlertEmail

# Register your models here.
admin.site.register(EmailSchedule)
admin.site.register(AlertEmail)