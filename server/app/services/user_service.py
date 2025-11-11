from datetime import datetime
from fastapi import HTTPException, status
from sqlalchemy.orm import Session

from app.core import security
from app.core.config import Settings
from app.models.user import User
from app.schemas.token import Token, TokenRefresh
from app.schemas.user import UserResponse


class UserService:
    def __init__(self, db: Session):
        self.db = db

    # ---------------------- Signup ----------------------
    def signup(self, name: str, email: str, password: str) -> UserResponse:
        # Check if user already exists
        existing_user = self.db.query(User).filter(User.email == email).first()
        if existing_user:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="User with this email already exists."
            )

        # Hash password and create user
        hashed_password = security.get_password_hash(password)
        new_user = User(
            name=name,
            email=email,
            password=hashed_password,
            created_at=datetime.utcnow()
        )
        self.db.add(new_user)
        self.db.commit()
        self.db.refresh(new_user)

        return UserResponse.from_orm(new_user)

    # ---------------------- Login -----------------------
    def login(self, email: str, password: str) -> Token:
        user = self.db.query(User).filter(User.email == email).first()
        if not user or not security.verify_password(password, user.password):
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid email or password."
            )

        # Prepare payload and create tokens
        payload = {"sub": user.email, "user_id": user.id}
        access_token = security.create_access_token(payload)
        refresh_token = security.create_refresh_token(payload)

        return Token(
            access_token=access_token,
            refresh_token=refresh_token,
            token_type="bearer",
            user=UserResponse.from_orm(user),
        )

    # ---------------------- Refresh ---------------------
    def refresh(self, refresh_token: str) -> TokenRefresh:
        try:
            payload = security.verify_refresh_token(refresh_token)
        except Exception:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid or expired refresh token.",
            )

        email = payload.get("sub")
        user_id = payload.get("user_id")

        if not email or not user_id:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid token payload.",
            )

        # Create new access token
        new_access_token = security.create_access_token({"sub": email, "user_id": user_id})

        return TokenRefresh(
            access_token=new_access_token,
            token_type="bearer"
        )