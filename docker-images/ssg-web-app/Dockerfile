# build
FROM node:22-alpine AS builder
RUN mkdir /build
WORKDIR /build

RUN npm install --global pnpm
COPY . .
RUN pnpm install
RUN pnpm build

# run app
FROM nginx:1.27.4-alpine
COPY --from=builder /build/dist /usr/share/nginx/html