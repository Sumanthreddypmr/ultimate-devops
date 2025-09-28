FROM node:18-slim

# Create app directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json (if available)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy app source code
COPY . .

# Expose the port
EXPOSE 3001

# Start the app
CMD ["node", "appointment-service.js"]
