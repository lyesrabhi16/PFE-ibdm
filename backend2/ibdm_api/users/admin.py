from django import forms
from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from users.models import User, Role, Permission

class AddUserForm(forms.ModelForm):

    role = forms.ModelChoiceField(queryset=Role.objects.all())
    class Meta:
        model = User
        fields = ['email', 'password', 'role']
    
    def save(self, commit=True):
        user : User = super().save(commit=False)
        user.set_password(self.cleaned_data["password"])
        if commit:
            user.save()
            print("User saved, adding groups")
            user.groups.add(user.role.group)
            print("User groups added", user.groups.all())
        return user

class CustomUserAdmin(UserAdmin):
    ordering = ['email', ]
    list_display = ['email', ]
    fieldsets = (
        (None, {'fields': ('username', 'email', 'password')}),
        ('Info', {'fields': ('first_name', 'last_name', 'phone_number', 'avatar')}),
        ('Permissions', {'fields': ('is_staff', 'is_admin', 'is_superuser','role',
                                    'groups', 'user_permissions')}),
        ('Important dates', {'fields': ('created_at', 'updated_at')}),
    )
    readonly_fields = ("created_at", 'updated_at')
    
    list_display = ("email", "username", "first_name", "last_name", "is_staff", "is_admin","is_superuser")
    list_filter = ("is_staff", "is_admin", "is_superuser")
    search_fields = ("username", "first_name", "last_name", "email")
    add_form = AddUserForm
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('email', 'password', 'role'),
        }),
    )
# Register your models here.
admin.site.register(User, CustomUserAdmin)
admin.site.register(Role)
admin.site.register(Permission)