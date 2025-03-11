from drf_spectacular.utils import extend_schema
from rest_framework import viewsets

def get_or_none(class_model, get_function, args, **kwargs):
    try:
        return get_function(*args, **kwargs)
    except class_model.DoesNotExist:
        return None

def with_operation_ids(
        on_list: str|None = None,
        on_retrieve: str|None = None,
        on_create: str|None = None,
        on_update: str|None = None,
        on_partial_update: str|None = None,
        on_destroy: str|None = None,
):
    def decorator(cls):
        if issubclass(cls, viewsets.ReadOnlyModelViewSet):
            class WrappedReadOnlyModelViewClass(cls):
                # Optionally, override methods if needed
                
                def __init__(self, *args, **kwargs):
                    super().__init__(*args, **kwargs)

                @extend_schema(
                    operation_id=on_list
                )
                def list(self, request, *args, **kwargs):
                    return super().list(request, *args, **kwargs)
                @extend_schema(
                    operation_id=on_retrieve
                )
                def retrieve(self, request, *args, **kwargs):
                    return super().retrieve(request, *args, **kwargs)
            
            WrappedReadOnlyModelViewClass.__name__ = cls.__name__
            WrappedReadOnlyModelViewClass.__doc__ = cls.__doc__
            WrappedReadOnlyModelViewClass.__module__ = cls.__module__
            return WrappedReadOnlyModelViewClass
        elif  issubclass(cls, viewsets.ModelViewSet):
            class WrappedModelViewSetClass(cls):
                # Optionally, override methods if needed
                
                def __init__(self, *args, **kwargs):
                    super().__init__(*args, **kwargs)

                @extend_schema(
                    operation_id=on_list
                )
                def list(self, request, *args, **kwargs):
                    return super().list(request, *args, **kwargs)
                @extend_schema(
                    operation_id=on_retrieve
                )
                def retrieve(self, request, *args, **kwargs):
                    return super().retrieve(request, *args, **kwargs)
                @extend_schema(
                    operation_id=on_create
                )
                def create(self, request, *args, **kwargs):
                    return super().create(request, *args, **kwargs)
                @extend_schema(
                    operation_id=on_update
                )
                def update(self, request, *args, **kwargs):
                    return super().update(request, *args, **kwargs)
                @extend_schema(
                    operation_id=on_partial_update
                )
                def partial_update(self, request, *args, **kwargs):
                    return super().partial_update(request, *args, **kwargs)
                @extend_schema(
                    operation_id=on_destroy
                )
                def destroy(self, request, *args, **kwargs):
                    return super().destroy(request, *args, **kwargs)
                
            
            WrappedModelViewSetClass.__name__ = cls.__name__
            WrappedModelViewSetClass.__doc__ = cls.__doc__
            WrappedModelViewSetClass.__module__ = cls.__module__
            return WrappedModelViewSetClass
        else:
            raise ValueError("This decorator only works with classes that inherit from viewsets.ModelViewSet or viewsets.ReadOnlyModelViewSet")
    return decorator