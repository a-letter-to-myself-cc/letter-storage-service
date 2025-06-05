FROM python:3.11-slim

WORKDIR /app

# 시스템 패키지 설치 (후에 캐시를 지우기 위해 && 사용)
RUN apt-get update && apt-get install -y gcc libpq-dev && rm -rf /var/lib/apt/lists/*

ARG LETTER_STORAGE_DB_HOST
ARG LETTER_STORAGE_DB_NAME
ARG LETTER_STORAGE_DB_USER
ARG LETTER_STORAGE_DB_PASSWORD
ARG LETTER_STORAGE_DB_PORT
ARG GCP_SA_KEY
ARG BUCKET_NAME
ARG SECRET_KEY

# 런타임 환경 변수 설정
ENV LETTER_STORAGE_DB_HOST=$LETTER_STORAGE_DB_HOST \
    LETTER_STORAGE_DB_NAME=$LETTER_STORAGE_DB_NAME \
    LETTER_STORAGE_DB_USER=$LETTER_STORAGE_DB_USER \
    LETTER_STORAGE_DB_PASSWORD=$LETTER_STORAGE_DB_PASSWORD \
    LETTER_STORAGE_DB_PORT=$LETTER_STORAGE_DB_PORT \
    GCP_SA_KEY=$GCP_SA_KEY \
    BUCKET_NAME=$BUCKET_NAME \
    SECRET_KEY=$SECRET_KEY

# requirements.txt를 먼저 복사하고 패키지 설치
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 나머지 애플리케이션 파일 복사
COPY . .

CMD ["gunicorn", "letter_storage_service.wsgi:application", "--bind", "0.0.0.0:8000"]