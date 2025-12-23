from datetime import timedelta
from unicodedata import name
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session

from app.core import security
from app.core.config import settings
from app.core.database import get_db
from app.schemas.token import Token, TokenRefresh,TokenRefreshRequest
from app.schemas.user import UserCreate,UserLogin,Logout
from app.services.user_service import UserService

router = APIRouter()
@router.post("/signup", response_model=Token)
def signup(user_data: UserCreate, db: Session = Depends(get_db)):
    user_service = UserService(db)
    
    try:
        user = user_service.signup(name=user_data.name, email=user_data.email, password=user_data.password)

        # Create both tokens on signup
        access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
        refresh_token_expires = timedelta(days=settings.REFRESH_TOKEN_EXPIRE_DAYS)
        
        access_token = security.create_access_token(
            data={"sub": user.email, "user_id": user.id},
            expires_delta=access_token_expires
        )
        
        refresh_token = security.create_refresh_token(
            data={"sub": user.email, "user_id": user.id},
            expires_delta=refresh_token_expires
        )
        
        return {
            "access_token": access_token,
            "refresh_token": refresh_token,
            "token_type": "bearer",
            "user": {
                "id": user.id,
                "email": user.email,
                "name": user.name,
                "created_at": user.created_at
            }
        }
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.post("/login", response_model=Token)
def login(login_data: UserLogin, db: Session = Depends(get_db)):
    user_service = UserService(db)
    
    user = user_service.authenticate_user(login_data.email, login_data.password)
    if not user:
        raise HTTPException(status_code=401, detail="Incorrect email or password")
    
    # Create BOTH tokens
    access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    refresh_token_expires = timedelta(days=settings.REFRESH_TOKEN_EXPIRE_DAYS)
    
    access_token = security.create_access_token(
        data={"sub": user.email, "user_id": user.id},
        expires_delta=access_token_expires
    )
    
    refresh_token = security.create_refresh_token(
        data={"sub": user.email, "user_id": user.id},
        expires_delta=refresh_token_expires
    )
    
    return {
        "access_token": access_token,
        "refresh_token": refresh_token, 
        "token_type": "bearer",
        "user": {
            "id": user.id,
            "email": user.email,
            "name": user.name,
            "created_at": user.created_at
        }
    }

@router.post("/refresh", response_model=TokenRefresh)
def refresh_token(request: TokenRefreshRequest, db: Session = Depends(get_db)):
    try:
        print( "Refreshing token..." )
        refresh_token = request.refresh_token
        print( "Received refresh token:", refresh_token )
        payload = security.verify_refresh_token(refresh_token)
        print( "Refresh token payload:", payload )
        email = payload.get("sub")
        user_id = payload.get("user_id")
        
        if not email or not user_id:
            raise HTTPException(status_code=401, detail="Invalid refresh token")
        
        # Create new access token
        access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
        access_token = security.create_access_token(
            data={"sub": email, "user_id": user_id},
            expires_delta=access_token_expires
        )
        
        return {
            "access_token": access_token,
            "token_type": "bearer"
        }
        
    except ValueError as e:
        raise HTTPException(status_code=401, detail=str(e))
    
@router.post("/logout", response_model=Logout)
def logout():
    return {"message": "Successfully logged out"}