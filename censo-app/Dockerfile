FROM python:3.11-slim
RUN apt-get update && apt-get install -y libpq-dev gcc
WORKDIR /app
COPY . .
RUN pip install flask psycopg2-binary
CMD ["python", "app.py"]
