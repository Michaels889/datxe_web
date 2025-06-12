# app/routes/booking.py
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app import crud, schemas, database
from fastapi_mail import FastMail, MessageSchema, ConnectionConfig
from pydantic import EmailStr

router = APIRouter()

conf = ConnectionConfig(
    MAIL_USERNAME = os.getenv("MAIL_USERNAME"),
    MAIL_PASSWORD = os.getenv("MAIL_PASSWORD"),
    MAIL_FROM = os.getenv("MAIL_FROM"),
    MAIL_PORT = 587,
    MAIL_SERVER = "smtp.gmail.com",
    MAIL_STARTTLS = True,
    MAIL_SSL_TLS = False,
    USE_CREDENTIALS = True
)

async def send_confirmation_email(to_email: EmailStr, name: str, seat: int):
    message = MessageSchema(
        subject="Xác nhận đặt vé",
        recipients=[to_email],
        body=f"Chào {name}, bạn đã đặt thành công ghế số {seat}. Cảm ơn bạn!",
        subtype="plain"
    )
    fm = FastMail(conf)
    await fm.send_message(message)

def get_db():
    db = database.SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/routes", response_model=schemas.Route)
def create_route(route: schemas.RouteCreate, db: Session = Depends(get_db)):
    return crud.create_route(db, route)

@router.get("/routes", response_model=list[schemas.Route])
def list_routes(db: Session = Depends(get_db)):
    return crud.get_routes(db)

@router.post("/schedules", response_model=schemas.Schedule)
def create_schedule(schedule: schemas.ScheduleCreate, db: Session = Depends(get_db)):
    return crud.create_schedule(db, schedule)

@router.get("/schedules", response_model=list[schemas.Schedule])
def list_schedules(route_id: int = None, db: Session = Depends(get_db)):
    return crud.get_schedules(db, route_id)
    
@router.post("/book")
def book_seat(booking: schemas.BookingCreate, db: Session = Depends(get_db)):
    try:
        return crud.create_booking(db, booking)
    except ValueError as e:
        return {"error": str(e)}
        
@router.get("/history", response_model=list[schemas.Booking])
def get_booking_history(phone: str, db: Session = Depends(get_db)):
    return crud.get_bookings_by_phone(db, phone)