# app/models.py
from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from app.database import Base

class Route(Base):
    __tablename__ = "routes"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, unique=True, index=True)
    origin = Column(String)
    destination = Column(String)

class Schedule(Base):
    __tablename__ = "schedules"
    id = Column(Integer, primary_key=True, index=True)
    route_id = Column(Integer, ForeignKey("routes.id"))
    departure_time = Column(DateTime)
    available_seats = Column(Integer)

class Booking(Base):
    __tablename__ = "bookings"
    id = Column(Integer, primary_key=True, index=True)
    schedule_id = Column(Integer, ForeignKey("schedules.id"))
    seat_number = Column(Integer)
    customer_name = Column(String)
    customer_phone = Column(String)