# Makefile for the Go backend application

# Variables
APP_NAME := backend-app
LINUX_APP_NAME := $(APP_NAME)-linux

.PHONY: all build build-linux run clean

# Default command
all: build

# Build for the local OS
build:
	@echo "Building for local OS..."
	go build -o $(APP_NAME) main.go
	@echo "Binary created: $(APP_NAME)"

# Build for Linux amd64
build-linux:
	@echo "Building for Linux (amd64)..."
	GOOS=linux GOARCH=amd64 go build -o $(LINUX_APP_NAME) main.go
	@echo "Linux binary created: $(LINUX_APP_NAME)"

# Run the application locally
run:
	@echo "Starting server on port 8090..."
	go run main.go

# Clean build artifacts
clean:
	@echo "Cleaning up binaries..."
	rm -f $(APP_NAME) $(LINUX_APP_NAME)
	@echo "Done."
