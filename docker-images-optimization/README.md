# Docker images optimization

Here i learn how to optimize images. First step i've taken is minimize linux distribution I need (we're talking production images here),
so i moved my go-app-dependencies image from docker-images to golang-alpine - effect was good, size decreased from 1.1GB to around 330MB.
Yet that wasn't enough:
* Here I introduced build step and run step to my application
* In go-app-optimized Dockerfile i defined golang-builder where I run alpine version and build binary
* Then nothing else than binary isn't really needed so I defined my actual run step where i've got linux-alpine only.
I create user, copy binary run it and it works just fine
* Size of image decreased to 15.2MB which is a lot percentagewise, so I'm happy with the result
  (ofc let's not overengineener, there is a point where this 5% lower size just isn't worth time)
* It's not a lot here but as I reckon in more complicated apps you can cut out a lot more like security things (cut out rest of executables from very slim alpine),
unused native dependencies, stuff like that

There are a few mentions for other distros that are alternative to alpine:
  * Debian slim
  * Distroless (very slim debian by google)
  * Redhat Universal Base Image micro
  * wolfi
  * nixos minimal
  * photon os maybe

All those will be enough in large ammount of cases propably but if there is need for further optimizations or to cover some edge cases
I'd have to dive deep and weigh some pros and cons