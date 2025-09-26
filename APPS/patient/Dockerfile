# ---- Base Image ----
FROM node:18-alpine AS base

# Set working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json (if exists)
COPY package*.json ./

# Install dependencies (production only)
RUN npm install --only=production

# Copy application code
COPY . .

# ---- Runtime Image ----
FROM node:18-alpine AS runtime

WORKDIR /usr/src/app

# Copy only the necessary files from base
COPY --from=base /usr/src/app /usr/src/app

# Expose port (matches patient-service.js)
EXPOSE 3000

# Start the service
CMD ["npm", "start"]
