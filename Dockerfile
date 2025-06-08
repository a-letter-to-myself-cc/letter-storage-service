FROM python:3.11-slim

WORKDIR /app

RUN apt-get update && apt-get install -y gcc libpq-dev && rm -rf /var/lib/apt/lists/*

# 런타임 환경 변수 설정
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# 앱 환경변수
ARG LETTER_STORAGE_DB_HOST
ARG LETTER_STORAGE_DB_NAME
ARG LETTER_STORAGE_DB_USER
ARG LETTER_STORAGE_DB_PASSWORD
ARG LETTER_STORAGE_DB_PORT
ARG GCP_SA_KEY
ARG BUCKET_NAME
ARG SECRET_KEY

ENV LETTER_STORAGE_DB_HOST=$LETTER_STORAGE_DB_HOST \
    LETTER_STORAGE_DB_NAME=$LETTER_STORAGE_DB_NAME \
    LETTER_STORAGE_DB_USER=$LETTER_STORAGE_DB_USER \
    LETTER_STORAGE_DB_PASSWORD=$LETTER_STORAGE_DB_PASSWORD \
    LETTER_STORAGE_DB_PORT=$LETTER_STORAGE_DB_PORT \
    GCP_SA_KEY=$GCP_SA_KEY \
    BUCKET_NAME=$BUCKET_NAME \
    SECRET_KEY=$SECRET_KEY

# requirements 먼저 복사 후 설치
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 앱 코드 및 entrypoint 복사
COPY . .
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# entrypoint 지정
ENTRYPOINT ["./entrypoint.sh"]

# 실행 명령
CMD ["gunicorn", "letter_storage_service.wsgi:application", "--bind", "0.0.0.0:8007"]