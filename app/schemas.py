# app/schemas.py
from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class RouteCreate(BaseModel):
    name: str
    origin: str
    destination: str

class Route(BaseModel):
    id: int
    name: str
    origin: str
    destination: str

    class Config:
        orm_mode = True

class ScheduleCreate(BaseModel):
    route_id: int
    departure_time: datetime
    available_seats: int

class Schedule(BaseModel):
    id: int
    route_id: int
    departure_time: datetime
    available_seats: int

    class Config:
        orm_mode = True
        
class BookingCreate(BaseModel):
    schedule_id: int
    seat_number: int
    customer_name: str
    customer_phone: str