# ---------- Build stage ----------
FROM node:18-alpine AS build

WORKDIR /app

# Copy dependency files first (for caching)
COPY package.json package-lock.json ./
RUN npm install

# Copy application source
COPY . .

# Build React app
RUN npm run build


# ---------- Production stage ----------
FROM nginx:alpine

# Remove default nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy build output to nginx
COPY --from=build /app/build /usr/share/nginx/html

# Expose nginx port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]

