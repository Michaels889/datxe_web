# app/main.py
from fastapi import FastAPI
from app.routes import routes
from app.database import engine, Base

app = FastAPI()
app.include_router(routes.router)

# Tạo bảng DB
Base.metadata.create_all(bind=engine)