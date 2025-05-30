from copy import deepcopy
from typing import Any, List
from django import forms
from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from django.db.models.fields.related import RelatedField
from django.db.models.query import QuerySet
from django.http import HttpRequest
from users.models import User, Role, Permission, UserManager, SubordinateAndSuperior
from logs.logging import logger as logging
from django.contrib.auth.models import Group
from users.views import getUsersQueryset

class AddUserForm(forms.ModelForm):

    role = forms.ModelChoiceField(queryset=Role.objects.all())

    def __init__(self, *args, **kwargs):
        request = kwargs.pop('request', None)
        super().__init__(*args, **kwargs)
        #print(f"AddUserForm __init__ called with args: {args}, kwargs: {kwargs}")
        # Set the widget for the password field to PasswordInput
        self.fields['password'].widget = forms.PasswordInput()
        # Set the widget for the email field to EmailInput
        self.fields['email'].widget = forms.EmailInput(attrs={'autocomplete': 'email'})
        #print(f"AddUserForm fields after init: {self.fields}")

    class Meta:
        model = User
        fields = ['email', 'password', 'role']

    def save(self, commit=True):
        #print(f"AddUserFrom save called with data: {self.cleaned_data}")
        if commit:
            return UserManager().create_user(**self.cleaned_data)
        user = User(**self.cleaned_data)
        user.set_password(self.cleaned_data['password'])
        return user
    def save_m2m(self):
        #print(f"AddUserForm save_m2m called with data: {self.cleaned_data}")
        return None
        
class SuperiorInline(admin.TabularInline):
    model = SubordinateAndSuperior
    extra = 1
    verbose_name = "Superior"
    verbose_name_plural = "Superior"
    fk_name = 'subordinate'
    autocomplete_fields = ('superior',)
    def get_queryset(self, request: HttpRequest) -> QuerySet:
        #print("SuperiorInline get_queryset called")
        qs = super().get_queryset(request)
        #print("SuperiorInline get_queryset qs:", qs)
        return super().get_queryset(request)
    def get_field_queryset(self, db, db_field, request):
        qs = super().get_field_queryset(db, db_field, request)
        return qs

class SubordinateInline(admin.TabularInline):
    model = SubordinateAndSuperior
    extra = 1
    verbose_name = "Subordinate"
    verbose_name_plural = "Subordinates"
    fk_name = 'superior'
    autocomplete_fields = ('subordinate',)


    def get_queryset(self, request: HttpRequest) -> QuerySet:
        #print("SubordinateInline get_queryset called")
        return super().get_queryset(request)
    def get_field_queryset(self, db, db_field, request):
        qs = super().get_field_queryset(db, db_field, request)
        
        # Only filter for the subordinate field
        if db_field.name == 'subordinate':
            if qs is None:
                # If no queryset was returned, get the default
                qs = db_field.remote_field.model._default_manager.all()
            
            # Exclude the current user from possible subordinates
            qs = qs.exclude(pk=request.user.pk)
            
        return qs
class CustomUserAdmin(UserAdmin):
    ordering = ['email', ]
    list_display = ['email', ]
    fieldsets = [
        (None, {'fields': ('username', 'email', 'password')}),
        ('Info', {'fields': ('first_name', 'last_name', 'phone_number', 'avatar')}),
        ('Permissions', {'fields': ('is_active', 'is_admin', 'is_superuser','role',
                                    'groups', 'user_permissions')}),
        ('Important dates', {'fields': ('created_at', 'updated_at')}),
    ]
    readonly_fields = ("created_at", 'updated_at')
    
    list_display = ("email", "username", "first_name", "last_name", "role", "is_admin", "is_superuser", "is_active")
    list_filter = ("is_admin", "is_superuser", "is_active")
    search_fields = ("username", "first_name", "last_name", "email")
    add_form = AddUserForm
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('email', 'password', 'role'),
        }),
    )
    inlines = [SuperiorInline, SubordinateInline]

    def get_fieldsets(self, request, obj=None):
        if not obj:
            return self.add_fieldsets
        fieldsets = super().get_fieldsets(request, obj)
        if request.user.is_superuser:
            # If the user is a superuser, show all fields
            return fieldsets
        permissions_fields = fieldsets.pop(2)
        permissions_fields[1]['fields'] = (
            'is_active', 'role',
            'groups', 'user_permissions'
        )
        fieldsets.insert(2, permissions_fields)
        return fieldsets
    

    def get_group_queryset(self, request):
        """
        Override to filter groups based on the user's permissions.
        If the user is a superuser, return all groups.
        Otherwise, return only the groups that the user can manage.
        """
        if request.user.is_superuser:
            return Group.objects.all()
        return request.user.role.managed_roles.all().values_list('group', flat=True)

    def get_form(self, request, obj=None, **kwargs):
        # Create form class outside the method if possible
        form_class = super().get_form(request, obj, **kwargs)
        
        class DynamicUserForm(form_class):
            def __init__(self, *args, **kwargs):

                super().__init__(*args, **kwargs)
                self.fields['role'].queryset = Role.objects.all() if request.user.is_superuser else request.user.role.managed_roles.all()
            def clean_role(self):
                role = self.cleaned_data.get('role')
                if not role:
                    raise forms.ValidationError("Role is required.")
                return role
            def clean_groups(self):
                groups = self.cleaned_data.get('groups', [])
                role = self.cleaned_data.get('role')
                old_role = self.instance.role
                if old_role.group in groups:
                    groups = groups.exclude(name=old_role.group.name)
                if role.group not in groups:
                    groups = groups | Group.objects.filter(name=role.group.name)
                return groups
        return DynamicUserForm
    

    def get_queryset(self, request: HttpRequest) -> QuerySet[Any]:
        return getUsersQueryset(request.user)
    def get_field_queryset(self, db, db_field, request):
        qs = super().get_field_queryset(db, db_field, request)
        if request.user.is_superuser:
            return qs
        if db_field.name.lower() == "groups":
            user_groups = request.user.role.managed_roles.all().values_list('group__name', flat=True)
            #print("Filtering groups for user:", request.user, " possible groups:", user_groups)
            qs = qs.filter(
                name__in= user_groups
            )
        
        #print("field:", db_field.name)
        
        if db_field.name.lower() == "user_permissions":
            user_permissions = []
            for role in request.user.role.managed_roles.all():
                user_permissions.extend(role.group.permissions.all())
            user_permissions = set(user_permissions)
            #print("user_permissions:", user_permissions)
            
            if qs is None:
                # If no queryset was returned, get the default
                qs = db_field.remote_field.model._default_manager.all()
            qs = qs.filter(
                codename__in=[perm.codename for perm in user_permissions]
            )
        return qs

    def get_search_results(self, request, queryset, search_term):
        queryset, use_distinct = super().get_search_results(request, queryset, search_term)
        #print("get_search_results called with search_term:", search_term)
        if 'autocomplete' in request.path:
            field_name = request.GET.get('field_name', None)
            #print("Field name for autocomplete:", field_name)
            #print("Queryset before filtering:", queryset)
            if field_name == 'superior':
                if request.user.is_superuser:
                    queryset = User.objects.all()
                else:
                    users_qs = getUsersQueryset(request.user)
                    users_ids = [user.pk for user in users_qs]
                    users_ids.append(request.user.pk)
                    queryset = User.objects.filter(pk__in=users_ids)
            # Exclude current user from autocomplete results
            else:
                queryset = queryset.exclude(pk=request.user.pk)

        # execlude the form user
        return queryset, use_distinct
    def get_inline_instances(self, request, obj=None):
        # Only show inlines when editing an existing object
        if obj:  # obj is None when adding a new instance
            return super().get_inline_instances(request, obj)
        return []
    def save_form(self, request: HttpRequest, form: forms.ModelForm, change: bool) -> Any:
        #print(f"Saving form: {form.cleaned_data}")
        if change:
            # Update an existing user
            #print("updating user")
            user = form.instance
            #print("form data", form.cleaned_data)
            data = deepcopy(form.cleaned_data)
            del data['password']
            user = UserManager().update_user(
                user.id,
                **data,
            )
            form.instance = user
            #print("User updated:", user.email)
        else:
            # Create a new user
            user = UserManager().create_user(
                **form.cleaned_data,
            )
            SubordinateAndSuperior.objects.create(
                subordinate=user,
                superior=request.user,
            )
            #print(f"User created: {user.email}")
        form.instance = user
        super().save_form(request, form, change)
        return user
    # Register your models here.

class CustomRoleAdmin(admin.ModelAdmin):
    list_display = ('group', 'color', 'is_admin')
    search_fields = ('group__name',)
    list_filter = ('group',)
    ordering = ('group__name',)
    fieldsets = [
        (None, {'fields': ('group', 'color', 'managed_roles', 'is_admin', 'created_at', 'updated_at')}),
    ]
    readonly_fields = ('created_at', 'updated_at')
    
    def get_queryset(self, request: HttpRequest) -> QuerySet[Any]:
        qs = super().get_queryset(request)
        if request.user.is_superuser:
            return qs
        return qs.filter(group__in=request.user.role.managed_roles.all().values_list('group', flat=True))
    def get_fieldsets(self, request, obj):
        fieldset = super().get_fieldsets(request, obj)
        if request.user.is_superuser:
            return fieldset
        f = fieldset.pop(0)
        f[1]['fields'] = ('group', 'color', 'managed_roles', 'created_at', 'updated_at')
        fieldset.insert(0, f)
        return fieldset
    def get_field_queryset(self, db, db_field, request):
        qs = super().get_field_queryset(db, db_field, request)
        if request.user.is_superuser:
            return qs
        if db_field.name.lower() == "managed_roles":
            # Filter managed roles based on the user's permissions
            qs = qs.filter(group__in=request.user.role.managed_roles.all().values_list('group', flat=True))
        elif db_field.name.lower() == "group":
            # Filter groups based on the user's permissions
            qs = qs.filter(name__in=request.user.role.managed_roles.all().values_list('group__name', flat=True))
        return qs
    def get_form(self, request, obj, change, **kwargs: Any):
        form = super().get_form(request, obj, change, **kwargs)
        class DynamicRoleForm(form):
            def clean_managed_roles(self):
                managed_roles = self.cleaned_data.get('managed_roles', [])
                if self.cleaned_data.get('group') in [role.group for role in managed_roles]:
                    raise forms.ValidationError("Managed roles cannot include the group this role represents.")
                return managed_roles
        return DynamicRoleForm

class CustomGroupAdmin(admin.ModelAdmin):
    list_display = ('name',)
    search_fields = ('name',)
    ordering = ('name',)
    fieldsets = [
        (None, {'fields': ('name', 'permissions')}),
    ]

    
    def get_queryset(self, request: HttpRequest) -> QuerySet:
        qs = super().get_queryset(request)
        if request.user.is_superuser:
            return qs
        qs = qs.filter(
            name__in=request.user.role.managed_roles.all().values_list('group__name', flat=True)
        )
        return qs
    def get_field_queryset(self, db, db_field, request):
        qs = super().get_field_queryset(db, db_field, request)
        if request.user.is_superuser:
            return qs
        if db_field.name.lower() == "permissions":
            # Filter permissions based on the user's managed roles
            user_permissions = []
            for role in request.user.role.managed_roles.all():
                user_permissions.extend(role.group.permissions.all())
            user_permissions = set(user_permissions)
            if qs is None:
                # If no queryset was returned, get the default
                qs = db_field.remote_field.model._default_manager.all()
            qs = qs.filter(
                codename__in=[perm.codename for perm in user_permissions]
            )
        return qs

admin.site.register(User, CustomUserAdmin)
admin.site.register(Role, CustomRoleAdmin)
admin.site.unregister(Group)  # Unregister the default Group model
admin.site.register(Group, CustomGroupAdmin)