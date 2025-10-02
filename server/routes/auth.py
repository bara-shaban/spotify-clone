import uuid
import bcrypt
from fastapi import HTTPException
from fastapi.params import Depends
from database import get_db
from models.user import User
from pydantic_schemas.user_create import UserCreate
from fastapi import APIRouter
from sqlalchemy.orm import Session

from pydantic_schemas.user_login import UserLogin


router = APIRouter()

@router.post('/signup',status_code=201)
def signup_user(user: UserCreate,db:Session=Depends(get_db)):
    userAlreadyExists = db.query(User).filter(User.email == user.email).first()
    if not userAlreadyExists:
        hashed_password = bcrypt.hashpw(user.password.encode(), bcrypt.gensalt(16))
        new_user = User(
            id=str(uuid.uuid4()),
            name=user.name,
            email=user.email,
            password=hashed_password
        )
        db.add(new_user)
        db.commit()
        db.refresh(new_user)
        return {"user": new_user, "message": "User created successfully"}


    raise HTTPException(400,'User already exists')


@router.post('/login')
def login_user(user:UserLogin,db:Session=Depends(get_db)):
    db_user = db.query(User).filter(User.email==user.email).first()
    if db_user:
        bcrypt_check = bcrypt.checkpw(user.password.encode(),db_user.password)
        if bcrypt_check:
            return {"user":db_user,"message":"User logged in successfully"}
        else:
            raise HTTPException(400,'Incorrect password.')
    else:
        raise HTTPException(400,'User with this email does not exist.')