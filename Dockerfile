#MULTI STEP BUILDS

#To install dependencies and build application
FROM node:alpine as builder 
WORKDIR '/app'
COPY package.json . 
RUN npm install
COPY . .
RUN npm run build

# --- NOTES ---
#We care about /app/build

#Because this is a prod build, we don't need volumes
#Which was done in order to have hot reload occur
#In prod we do not need that!

#CMD vs RUN
# CMD - initial command to run after build (only ONE can be defined, last used others ignored)
# RUN - what to run during the build process, will affect image by committing results (update image ref hash)

# !--- NOTES ---!

#Second step

FROM nginx
COPY --from=builder /app/build /usr/share/nginx/html
# the nginx directory is found in docs
# this step is important, we're essentially dumping everything from the build phase except the final build output
# reducing the total size of the container drastically (node_modules is roughly 155mb alone).. we don't need
# dep files anymore since we only need them to build