from datetime import datetime, timedelta, timezone
from jose import jwt  # use python-jose for consistency with FastAPI
from passlib.context import CryptContext

from app.core.config import settings


pwd_context = CryptContext(
    schemes=["bcrypt"],
    deprecated="auto",
)

# -------------------- Password Hashing --------------------
def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)


def get_password_hash(password: str) -> str:
    if isinstance(password, bytes):
        password = password.decode("utf-8")
    if len(password) > 72:
        raise ValueError("Password cannot exceed 72 characters")
    hashed = pwd_context.hash(password)
    if isinstance(hashed, bytes):
        hashed = hashed.decode("utf-8")
    return hashed


# -------------------- JWT Creation --------------------
def create_access_token(data: dict, expires_delta: timedelta | None = None) -> str:
    """Generate an access token with expiration."""
    to_encode = data.copy()
    expire = datetime.now(timezone.utc) + (
        expires_delta or timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    )
    to_encode.update({"exp": expire, "type": "access"})

    encoded_jwt = jwt.encode(
        to_encode,
        settings.ACCESS_TOKEN_SECRET_KEY,
        algorithm=settings.ALGORITHM,
    )
    return encoded_jwt


def create_refresh_token(data: dict, expires_delta: timedelta | None = None) -> str:
    """Generate a refresh token with expiration."""
    to_encode = data.copy()
    expire = datetime.now(timezone.utc) + (
        expires_delta or timedelta(days=settings.REFRESH_TOKEN_EXPIRE_DAYS)
    )
    to_encode.update({"exp": expire, "type": "refresh"})

    encoded_jwt = jwt.encode(
        to_encode,
        settings.REFRESH_TOKEN_SECRET_KEY,
        algorithm=settings.ALGORITHM,
    )
    return encoded_jwt


# -------------------- JWT Verification --------------------
def verify_refresh_token(token: str) -> dict:
    """Validate refresh token and return its payload."""
    try:
        payload = jwt.decode(
            token,
            settings.REFRESH_TOKEN_SECRET_KEY,
            algorithms=[settings.ALGORITHM],
        )
        if payload.get("type") != "refresh":
            raise ValueError("Not a refresh token")
        return payload
    except jwt.ExpiredSignatureError:
        raise ValueError("Refresh token expired")
    except jwt.JWTError:
        raise ValueError("Invalid refresh token")


def verify_token(token: str) -> dict:
    """Validate access token and return its payload."""
    try:
        payload = jwt.decode(
            token,
            settings.ACCESS_TOKEN_SECRET_KEY,
            algorithms=[settings.ALGORITHM],
        )
        return payload
    except jwt.ExpiredSignatureError:
        raise ValueError("Token has expired")
    except jwt.JWTError:
        raise ValueError("Invalid token")