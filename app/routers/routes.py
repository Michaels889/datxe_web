# app/routes/routes.py
from fastapi import APIRouter
from app.routes import booking

router = APIRouter()
router.include_router(booking.router, prefix="/booking", tags=["Booking"])