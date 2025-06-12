# app/crud.py
from sqlalchemy.orm import Session
from app import models, schemas

def create_route(db: Session, route: schemas.RouteCreate):
    db_route = models.Route(**route.dict())
    db.add(db_route)
    db.commit()
    db.refresh(db_route)
    return db_route

def get_routes(db: Session):
    return db.query(models.Route).all()

def create_schedule(db: Session, schedule: schemas.ScheduleCreate):
    db_schedule = models.Schedule(**schedule.dict())
    db.add(db_schedule)
    db.commit()
    db.refresh(db_schedule)
    return db_schedule

def get_schedules(db: Session, route_id: int = None):
    if route_id:
        return db.query(models.Schedule).filter(models.Schedule.route_id == route_id).all()
    return db.query(models.Schedule).all()
    
def create_booking(db: Session, booking: schemas.BookingCreate):
    db_booking = models.Booking(**booking.dict())

    # Giảm số ghế trống trong lịch chạy
    schedule = db.query(models.Schedule).filter(models.Schedule.id == booking.schedule_id).first()
    if not schedule or schedule.available_seats <= 0:
        raise ValueError("Lịch chạy không hợp lệ hoặc đã hết chỗ")

    schedule.available_seats -= 1
    db.add(db_booking)
    db.commit()
    db.refresh(db_booking)
    return db_booking