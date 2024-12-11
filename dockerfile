# Use a Node.js base image
FROM node:16 as build

# Set the working directory inside the container
WORKDIR /app

# Copy the package.json and yarn.lock files to the container
COPY package.json yarn.lock ./

# Install dependencies
RUN yarn install

# Copy the rest of the application code to the container
COPY . .

# Build the React Native web app
RUN yarn build

# Use a minimal web server for serving the built app
FROM nginx:stable-alpine

# Copy the build output from the previous stage
COPY --from=build /app/build /usr/share/nginx/html

# Expose the default port used by NGINX
EXPOSE 80

# Command to run NGINX
CMD ["nginx", "-g", "daemon off;"]
