import os
import random
import time
import uuid

from faker import Faker
from psycopg.types.json import Json
from psycopg_pool import AsyncConnectionPool, ConnectionPool

pool = ConnectionPool(
    "dbname=postgres user=my_user password=my_password host=localhost port=5432",
    min_size=1,
    max_size=10,
)

# async_pool = AsyncConnectionPool(
#     "dbname=postgres user=my_user password=my_password host=localhost port=5432",
#     min_size=1,
#     max_size=10,
# )


def write_data(data: dict):
    with pool.connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                "INSERT INTO app.my_table (data) VALUES (%s) RETURNING id",
                [Json(data)],
            )


# async def async_write_data(data: dict):
#     async with async_pool.connection() as conn:
#         async with conn.cursor() as cur:
#             await cur.execute(
#                 "INSERT INTO app.my_table (data) VALUES (%s) RETURNING id",
#                 [Json(data)],
#             )


def main():
    print("Starting")
    f = Faker(locale="en_AU")

    for _ in range(1000):
        time.sleep(random.randint(1, 5) / 100)
        data = {
            "name": f.name(),
            "uuid": str(uuid.uuid1()),
            "email": f.email(),
            "phone_number": f.phone_number(),
            "address": f.address(),
            "date_of_birth": f.date_of_birth(
                minimum_age=18, maximum_age=80
            ).isoformat(),
            "job": f.job(),
            "company": f.company(),
            "ssn": f.ssn(),
            "url": f.url(),
            "ipv4": f.ipv4(),
            "ipv6": f.ipv6(),
            "user_agent": f.user_agent(),
        }
        write_data(data)


if __name__ == "__main__":
    main()
