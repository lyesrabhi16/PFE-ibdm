
class ErrorCode():
    def __init__(self, status_code:int, code:str) -> None:
        self.status_code = status_code
        self.code = code

class ErrorCodes:
    # ...
    INVALID_REQUEST = ErrorCode(
        status_code=400,
        code="invalid_input"
    )
    # ...
    INVALID_CREDENTIALS = ErrorCode(
        status_code=401,
        code="invalid_credentials"
    )

    @classmethod
    def getChoices(cls):
        codes = []
        codes.extend(
            (value.code, value.code)
            for value in vars(cls).values()
            if isinstance(value, ErrorCode)
        )
        return codes
