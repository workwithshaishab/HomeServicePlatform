import enum
import uuid

from sqlalchemy import (
    Boolean,
    Column,
    DateTime,
    Enum,
    Float,
    ForeignKey,
    Integer,
    String,
    UniqueConstraint,
    func,
)
from sqlalchemy.dialects.postgresql import UUID

from app.database import Base


class UserRole(str, enum.Enum):
    customer = "customer"
    provider = "provider"


class VerificationStatus(str, enum.Enum):
    pending = "pending"
    verified = "verified"
    rejected = "rejected"


class User(Base):
    """
    A single person can hold both a 'customer' account and a 'provider'
    account with the same email/phone — that's why uniqueness is scoped
    to (identifier, role) rather than to the identifier alone.
    """

    __tablename__ = "users"
    __table_args__ = (
        UniqueConstraint("email", "role", name="uq_users_email_role"),
        UniqueConstraint("phone", "role", name="uq_users_phone_role"),
    )

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    full_name = Column(String(255), nullable=False)
    email = Column(String(255), nullable=True, index=True)
    phone = Column(String(20), nullable=True, index=True)
    password_hash = Column(String(255), nullable=False)
    role = Column(Enum(UserRole, name="user_role"), nullable=False, index=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())


class CustomerProfile(Base):
    __tablename__ = "customer_profiles"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(
        UUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        unique=True,
        index=True,
    )
    name = Column(String(255), nullable=False)
    address = Column(String(500), nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())


class ProviderProfile(Base):
    __tablename__ = "provider_profiles"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(
        UUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        unique=True,
        index=True,
    )
    name = Column(String(255), nullable=False)
    service_category = Column(String(100), nullable=True, index=True)
    experience = Column(Integer, nullable=True)  # years of experience
    address = Column(String(500), nullable=True)
    verification_status = Column(
        Enum(VerificationStatus, name="verification_status"),
        nullable=False,
        default=VerificationStatus.pending,
    )
    availability = Column(Boolean, nullable=False, default=True)

    # Not in the original spec, but the existing "Top Rated Professionals"
    # UI needs a rating to display — remove if you're tracking this
    # elsewhere (e.g. a separate reviews table).
    rating = Column(Float, nullable=False, default=0.0)
    reviews_count = Column(Integer, nullable=False, default=0)

    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
