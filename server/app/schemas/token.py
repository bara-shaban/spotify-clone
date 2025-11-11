from pydantic import BaseModel
from app.schemas.user import UserResponse


# ---------------------- Login/Signup Token ----------------------
class Token(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str
    user: UserResponse


# ---------------------- Refresh Token Response ----------------------
class TokenRefresh(BaseModel):
    access_token: str
    token_type: str

# ---------------------- Refresh Token Request ----------------------
class TokenRefreshRequest(BaseModel):
    refresh_token: str