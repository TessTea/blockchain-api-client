# Start from the official golang base image
FROM golang:1.20-alpine as builder

# Set the working directory inside the container
WORKDIR /app

# Copy go.mod and go.sum files to the container
COPY go.mod go.sum ./

# Download all dependencies
RUN go mod download

# Copy the source code into the container
COPY . .

# Build the application
RUN go build -o app .

# Start a new stage from scratch
FROM alpine:latest

# Set the working directory
WORKDIR /root/

# Copy the binary from the builder stage
COPY --from=builder /app/app .
COPY --from=builder /app/config.yml .

# Expose the port used by the application
EXPOSE 8080

# Run the application
CMD ["./app"]
