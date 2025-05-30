from enum import unique
from tabnanny import verbose
from tokenize import group
from typing import Any, Iterable
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, Group, Permission, PermissionsMixin
from django.db import models
from drf_spectacular.utils import extend_schema, extend_schema_field
from drf_spectacular.types import OpenApiTypes
from django.core.exceptions import ValidationError
from colorfield.fields import ColorField
from django.utils.translation import gettext_lazy as _
# Create your models here.

class UserManager(BaseUserManager):
    
    def update_user(self, id, password=None, **extra_fields):
        #print("Updating user with ID:", id)
        user_permissions = extra_fields.pop("user_permissions", [])
        groups = extra_fields.pop("groups", [])

        user = User.objects.get(pk=id)
        #print("removing original user role group from his groups")
        #print("group to be removed:", user.role.group)
        groups = set(filter(lambda x: x.name != user.role.group.name, groups))
        #print("new groups:", groups)

        for key, value in extra_fields.items():
            setattr(user, key, value)
        if password: 
            user.set_password(password)
        user.save()
        user.is_admin = user.role.is_admin
        
        groups = {*groups, user.role.group}
        if user.is_superuser:
            groups.add(Group.objects.get_or_create(name="ADMIN_SYSTEM")[0])
        else:
            groups.discard(Group.objects.get_or_create(name="ADMIN_SYSTEM")[0])
        #print("Groups to be set:", groups)
        user.groups.set(groups)
        
        #print("User permissions to be set:", user_permissions)
        user.user_permissions.set(user_permissions)
        #print("Saving user")
        user.save()
        #print("User updated:", user.email)
        return user
    
    
    def create_user(self, email, password, role, **extra_fields):
        #print("Creating user with role:", role)
        if not email:
            raise ValueError("Users must have an email address")
        if not password:
            raise ValueError("Users must have a password")
        user_permissions = extra_fields.pop("user_permissions", [])
        user_permissions.append(Permission.objects.get(codename="can_view_settings_page"))
        #print("init user")
        user = User(
            email=self.normalize_email(email),
            role=role,
            **extra_fields
        )
        #print("set user password")
        user.set_password(password)
        #print("save user without permissions")
        user.save()
        #print("set user permissions")
        user.is_admin = role.is_admin
        #print("set user groups")
        user.groups.add(role.group)
        if user.is_superuser:
            user.groups.add(Group.objects.get_or_create(name="ADMIN_SYSTEM")[0])
        user.user_permissions.set(user_permissions)
        user.save()
        #print("User created:", user.email)
        return user

    def create_superuser(self, email, password):
        group = Group.objects.get_or_create(name="ADMIN_SYSTEM")[0]
        role = Role.objects.get_or_create(group=group, is_admin=True)[0]
        user = self.create_user(
            email=email,
            password=password,
            role=role
        )
        user.set_password(password)

        user.is_active = True
        user.is_admin = True
        user.is_superuser = True

        user.save()
        user.groups.add(group)
        user.save()
        return user
    
    # Add save_m2m method for compatibility with forms
    def save_m2m(self, *args, **kwargs):
        """
        This method is required for compatibility with forms that handle M2M fields
        """
        # No-op since we handle M2M in create/update methods
        print("Saving M2M relationships")
        print("Args:", args)
        print("Kwargs:", kwargs)
        #pass
        return super().save_m2m(*args, **kwargs)
class Role(models.Model):
    group = models.OneToOneField(Group, on_delete=models.CASCADE, related_name="role", unique=True)
    color = ColorField(max_length=7, default="#000000")
    managed_roles = models.ManyToManyField("Role", blank=True)
    is_admin = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    class Meta:
        verbose_name = _("Role")
        verbose_name_plural = _("Roles")
    def __str__(self):
        return f"{self.group.name}"

    def get_group(self):
        return self.group

    @extend_schema_field(OpenApiTypes.STR)
    def group__name(self):
        return self.group.name
    def save(self, *args, **kwargs):
        role = super().save(*args, **kwargs)
        #print("saved role:", self)

        admin_system_group = Group.objects.get_or_create(name="ADMIN_SYSTEM")[0]
        admin_system_role = Role.objects.get_or_create(group=admin_system_group, is_admin=True)[0]
        
        if self == admin_system_role:
            if not self.is_admin:
                self.is_admin = True
                self.save()
            if not self.managed_roles.filter(pk=self.pk).exists():
                self.managed_roles.set({
                    *self.managed_roles.all(),
                    self
                })
                self.save()

        if self != admin_system_role:
            admin_system_role.managed_roles.set({
                *admin_system_role.managed_roles.all(),
                self
            })
            admin_system_role.save()
            #print("added role to admin_system managed roles")

        return role
    



class SubordinateAndSuperior(models.Model):
    superior = models.ForeignKey("User", on_delete=models.CASCADE, related_name="superior")
    subordinate = models.ForeignKey("User", on_delete=models.CASCADE, related_name="subordinate", unique=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        unique_together = ("superior", "subordinate")
    def __str__(self):
        return f"{self.superior.email} {self.superior.role} is superior to {self.subordinate.email} {self.subordinate.role}"
    def clean(self):
        super().clean()
        self._check()

    def _check(self):

        if self.superior == self.subordinate:
            raise ValidationError({
                "superior": "A user cannot be their own superior.",
                "subordinate": "A user cannot be their own subordinate."
            })

        # Check for circular hierarchy
        current_superior = self.superior
        while current_superior:
            if current_superior == self.subordinate:
                raise ValidationError("Circular hierarchy detected: A user cannot be their own superior indirectly.")
            try:
                current_superior = SubordinateAndSuperior.objects.get(subordinate=current_superior).superior
            except SubordinateAndSuperior.DoesNotExist:
                break
    def save(self, *args, **kwargs):
        print("Saving SubordinateAndSuperior instance superior", self.superior, "subordinate", self.subordinate)
        self.full_clean()  # This will call clean() and perform validation checks
        ins = super().save(*args, **kwargs)
        #print("Checks passed")
        print("SubordinateAndSuperior instance saved:", self.superior, "is superior to", self.subordinate)
        return ins 
        #print("SubordinateAndSuperior instance saved")

class User(AbstractBaseUser, PermissionsMixin):
    first_name = models.CharField(max_length=50, blank=True)
    last_name = models.CharField(max_length=50, blank=True)
    username = models.CharField(max_length=255, blank=True)
    email = models.EmailField(unique=True)
    password = models.CharField(max_length=255)
    phone_number = models.CharField(max_length=15, validators=[], blank=True)
    avatar = models.ImageField(upload_to="images/avatars/", blank=True)
    role = models.ForeignKey(Role, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    is_active = models.BooleanField(default=True)
    is_admin = models.BooleanField(default=False)
    is_superuser = models.BooleanField(default=False)
    
    EMAIL_FIELD = "email"
    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = ["password"]
    
    objects = UserManager()
    def __str__(self):
        return f"{self.email}"

    def has_perm(self, perm: str, obj: models.Model | None = None) -> bool:
        
        if self.is_superuser:
            return True
        if self.role.group.permissions.filter(codename=perm).exists():
            return True
        if self.groups.filter(permissions__codename=perm).exists():
            return True
        if self.user_permissions.filter(codename=perm).exists():
            return True
        
        return super().has_perm(perm, obj)
    
    @property
    def is_staff(self) -> bool:
        return self.is_admin
    class Meta:
        verbose_name = _("Utilisateur")
        verbose_name_plural = _("Utilisateurs")
        permissions = [
            ("can_view_users_page", "Can view users page"),
            ("can_view_filtration_page", "Can view filtration page"),
            ("can_view_siroperie_page", "Can view siroperie page"),
            ("can_view_settings_page", "Can view settings page"),
            ("can_view_email_schedule_settings", "Can view email schedule settings"),
            ("can_view_email_alerts", "Can view email alerts"),
            ("can_view_emails_sent", "Can view emails sent"),
            ("can_view_utilite_page", "Can view utilite page"),
            ("can_view_co2_page", "Can view co2 page"),
            ("can_view_server_settings_page", "Can view server settings page"),
            ("can_view_server_status_page", "Can view server status page"),
            ("can_view_sucre_reports_page", "Can view sucre reports page"),
            ("can_view_filtration_reports_page", "Can view filtration reports page"),
            ("can_view_utilite_reports_page", "Can view utilite reports page"),
            ("can_view_co2_reports_page", "Can view co2 reports page"),
            ("can_view_documentation_page", "Can view documentation page"),
            ("can_view_groups_page", "Can view groups page"),
            ("can_view_roles_page", "Can view roles page"),
        ]
    
