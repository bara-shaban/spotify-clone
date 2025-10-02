from models.base import Base
from sqlalchemy import TEXT, VARCHAR, LargeBinary, Column

class User(Base):
    __tablename__ = 'user'
    id = Column(TEXT, primary_key=True, index=True)
    name = Column(VARCHAR(100), index=True)
    email = Column(VARCHAR(100), unique=True, index=True)
    password = Column(LargeBinary)
