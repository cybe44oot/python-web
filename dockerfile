FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Copy the app files to the container
COPY . /app

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port
EXPOSE 9090

# Run the application
CMD ["python", "app.py"]
