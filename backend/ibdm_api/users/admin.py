from typing import Any, List
from django import forms
from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from django.http import HttpRequest
from users.models import User, Role, Permission, UserManager
from logs.logging import logger as logging
from django.contrib.auth.models import Group
class AddUserForm(forms.ModelForm):

    role = forms.ModelChoiceField(queryset=Role.objects.all())
    class Meta:
        model = User
        fields = ['email', 'password', 'role']
    
    def save(self, commit=True):
        #print(f"AddUserFrom save called with data: {self.cleaned_data}")
        if commit:
            return UserManager().create_user(**self.cleaned_data)
        user = User(**self.cleaned_data, commit=False)
        user.set_password(self.cleaned_data['password'])
        return user
    def save_m2m(self):
        #print(f"AddUserForm save_m2m called with data: {self.cleaned_data}")
        return None
        

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
    def save_form(self, request: HttpRequest, form: forms.ModelForm, change: bool) -> Any:
        #print(f"Saving form: {form.cleaned_data}")
        if change:
            # Update an existing user
            user = form.instance
            user = UserManager().update_user(
                user.id,
                **form.cleaned_data,
            )
            #print("User updated:", user.email)
        else:
            # Create a new user
            user = UserManager().create_user(
                **form.cleaned_data,
            )
            #print(f"User created: {user.email}")
        return user
    def save_m2m(self, request: HttpRequest, form: forms.ModelForm, change: bool) -> Any:
        #print(f"Saving m2m for user: {form.instance.email}")
        return None
    def save_related(self, request: HttpRequest, form: forms.ModelForm, formsets: forms.BaseModelFormSet, change: bool) -> None:
        #print("Saving related objects")
        pass
# Register your models here.
admin.site.register(User, CustomUserAdmin)
admin.site.register(Role)
admin.site.register(Permission)