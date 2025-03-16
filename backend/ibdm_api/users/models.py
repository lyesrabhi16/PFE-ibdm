from typing import Any
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, Group, Permission, PermissionsMixin
from django.db import models
from drf_spectacular.utils import extend_schema, extend_schema_field
from drf_spectacular.types import OpenApiTypes
# Create your models here.

class UserManager(BaseUserManager):
    
    def update_user(self, id, password=None, **extra_fields):
        user_permissions = extra_fields.pop("user_permissions", [])

        user = User.objects.get(pk=id)
        for key, value in extra_fields.items():
            setattr(user, key, value)
        if password: 
            user.set_password(password)
        user.save()
        user.is_admin = user.role.is_admin
        user.groups.add(user.role.group)
        user.user_permissions.set(user_permissions)
        user.save()
        return user
    
    
    def create_user(self, email, password, role, **extra_fields):
        if not email:
            raise ValueError("Users must have an email address")
        if not password:
            raise ValueError("Users must have a password")
        user_permissions = extra_fields.pop("user_permissions", [])
        user = User(
            email=self.normalize_email(email),
            role=role,
            **extra_fields
        )
        user.set_password(password)
        user.save()
        user.is_admin = role.is_admin
        user.groups.add(role.group)
        user.user_permissions.set(user_permissions)
        user.save()
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

        user.is_admin = role.is_admin
        user.is_staff = True
        user.is_superuser = True

        user.save()
        user.groups.add(group)
        return user

class Role(models.Model):
    group = models.OneToOneField(Group, on_delete=models.CASCADE, related_name="role", unique=True)
    color = models.CharField(max_length=7, default="#000000")
    managed_roles = models.ManyToManyField("Role", blank=True)
    is_admin = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return f"{self.group.name}"

    def get_group(self):
        return self.group

    @extend_schema_field(OpenApiTypes.STR)
    def group__name(self):
        return self.group.name


class SubordinateAndSuperior(models.Model):
    superior = models.ForeignKey("User", on_delete=models.CASCADE, related_name="superior")
    subordinate = models.ForeignKey("User", on_delete=models.CASCADE, related_name="subordinate")
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.superior.email} {self.superior.role} is superior to {self.subordinate.email} {self.subordinate.role}"

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

    is_staff = models.BooleanField(default=False)
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

    class Meta:
        permissions = [
            ('can_view_users_page', 'Can view users page'),
            ('can_view_filtration_page', 'Can view filtration page'),
            ('can_view_siroperie_page', 'Can view siroperie page'),
            ('can_view_settings_page', 'Can view settings page'),
            ('can_view_email_schedule_settings', 'Can view email schedule settings'),
            ('can_view_email_alerts', 'Can view email alerts'),
            ('can_view_emails_sent', 'Can view emails sent'),
        ]
    
