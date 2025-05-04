# Use an official Python runtime as a parent image
FROM python:3.11-slim

# Set the working directory in the container
WORKDIR /app

# Install system dependencies required by Playwright and Chromium
# Using apt-get update && apt-get install -y --no-install-recommends \
# to reduce image size
RUN apt-get update && apt-get install -y --no-install-recommends \
    # List of dependencies commonly needed for Chromium on Debian/Ubuntu
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libgbm1 \
    libasound2 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libxshmfence1 \
    libxtst6 \
    libappindicator3-1 \
    libdbus-glib-1-2 \
    libfontconfig1 \
    libgdk-pixbuf2.0-0 \
    libgtk-3-0 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libx11-xcb1 \
    libxcb-dri3-0 \
    libxcb-shm0 \
    libxcursor1 \
    libxi6 \
    libxss1 \
    wget \
    ca-certificates \
    fonts-liberation \
    # Clean up apt cache to save space
    && rm -rf /var/lib/apt/lists/*

# Copy the requirements file into the container at /app
COPY requirements.txt .

# Install any needed packages specified in requirements.txt
# Using --no-cache-dir to reduce image size
RUN pip install --no-cache-dir -r requirements.txt

# Install Playwright browsers (only Chromium in this case, without system deps flag)
RUN playwright install chromium

# Copy the rest of the application code into the container at /app
# Assuming app.py, templates/, static/, and gunicorn.conf.py are in the root
COPY app.py .
COPY templates/ ./templates/
COPY static/ ./static/
# Uncomment the next line if gunicorn.conf.py exists and is needed
# COPY gunicorn.conf.py .

# Make port 5000 available to the world outside this container (adjust if needed)
# Render uses the PORT environment variable, Gunicorn should respect it
# EXPOSE 5000

# Define environment variable (optional, Render can inject this too)
# ENV PORT=5000

# Run app.py when the container launches
# Using the same command as in the original render.yaml
# Gunicorn typically binds to 0.0.0.0 by default and uses the PORT env var if set by Render
# Remove '-c gunicorn.conf.py' if the file doesn't exist or isn't needed
CMD ["gunicorn", "app:app", "-c", "gunicorn.conf.py"]

