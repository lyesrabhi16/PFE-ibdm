from rest_framework.pagination import PageNumberPagination
from rest_framework.response import Response


class CustomPagination(PageNumberPagination):
    page_size = 10
    page_size_query_param = "per_page"
    max_page_size = 1000

    def paginate_queryset(self, queryset, request, view=None):
        self.request = request
        enable_pagination: bool = request.query_params.get("enable_pagination", True)
        if isinstance(enable_pagination, str):
            enable_pagination = enable_pagination.lower() == "true"
            if not enable_pagination:
                return queryset
                
        return super().paginate_queryset(queryset, request, view)

    def get_paginated_response(self, data):
        enable_pagination: bool = self.request.query_params.get(
            "enable_pagination", True
        )
        if isinstance(enable_pagination, str):
            enable_pagination = enable_pagination.lower() == "true"

        if not enable_pagination:
            length = len(data)
            return Response({
                "next_url": None,
                "previous_url": None,
                "total_pages": 1,
                "total_results": length,
                "per_page": length,
                "current_page": 1,
                "data": data,
            })

        return Response(
            {
                "next_url": self.get_next_link(),
                "previous_url": self.get_previous_link(),
                "total_pages": self.page.paginator.num_pages,
                "total_results": self.page.paginator.count,
                "per_page": self.get_page_size(self.request),
                "current_page": self.page.number,
                "data": data,
            }
        )
    def get_schema_operation_parameters(self, view):
        return [
            {
                "name": "page",
                "in": "query",
                "description": "Page number",
                "required": False,
                "schema": {
                    "type": "integer",
                },
            },
            {
                "name": "per_page",
                "in": "query",
                "description": "Number of results per page",
                "required": False,
                "schema": {
                    "type": "integer",
                },
            },
            {
                "name": "enable_pagination",
                "in": "query",
                "description": "Enable or disable pagination",
                "required": False,
                "schema": {
                    "type": "boolean",
                },
            }
        ]

    def get_paginated_response_schema(self, schema):
        return {
            "type": "object",
            "properties": {
                "next_url": {
                    "type": "string",
                    "nullable": True,
                    "format": "uri",
                    "example": "http://example.com/api/v1/users/?page=2",
                },
                "previous_url": {
                    "type": "string",
                    "nullable": True,
                    "format": "uri",
                    "example": "http://example.com/api/v1/users/?page=1",
                },
                "total_pages": {"type": "integer", "example": 10},
                "total_results": {"type": "integer", "example": 100},
                "per_page": {"type": "integer", "example": 10},
                "current_page": {"type": "integer", "example": 1},
                "data": schema,
            },
        }
