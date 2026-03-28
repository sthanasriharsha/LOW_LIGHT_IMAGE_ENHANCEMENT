# Use slim Python 3.11 base image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies for OpenCV and general utilities
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first to leverage Docker cache
COPY requirements.txt .

# Upgrade pip and install Python dependencies
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY app.py .
COPY image_processing.py .

# Expose the port your Flask app will run on
EXPOSE 5000

# Set environment variable for Flask (optional but recommended)
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV WEB_CONCURRENCY=1

# Start the application
CMD ["python", "app.py"]
