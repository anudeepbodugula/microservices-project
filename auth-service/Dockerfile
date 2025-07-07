##### STAGE 1: Build Stage #####
FROM python:3.11-slim AS builder 

WORKDIR /app

COPY requirements.txt .

# Upgrade pip and install dependencies into a clean directory
RUN pip install --upgrade pip
RUN pip install --prefix=/install --no-cache-dir -r requirements.txt

# Copy app code
COPY app.py .

##### STAGE 2: Final Stage #####
FROM python:3.11-slim

RUN adduser --disabled-password --gecos '' flaskuser

WORKDIR /app

COPY --from=builder /install /usr/local
COPY --from=builder /app/app.py .

RUN chown -R flaskuser:flaskuser /app
USER flaskuser

EXPOSE 5001

CMD [ "python", "app.py" ]
