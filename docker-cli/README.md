# Docker CLI

Nothing really interesting here, just me taking notes on some of most useful/frequent
docker cli commands, ultimately docker --help will come in clutch in
situations beside simple runs, execs etc

So:
* docker run - flags -t and -i are "kinda" cool (tty + interactive), honorable mentions:
  * -d to detatch and run in bg
  * --rm to cleanup after exit
  * --name for not looking for hash or random name
* docker attach - to attach to existing container and its entrypoint process
* docker exec <?cmd> - execute command, could be default (entrypoint) or specific, like we can run exec cat /etc/issue in postgres container and it will print linux distro
* docker kill <cnt> - don't have to explain this one
* docker ps - shows running containers, --all flag to view history
* docker system - useful prune subcommand, clears history which can take up considerable space after some time
* docker rm/rmi <name> - remove container without auto rm/image 
* docker search - quick search dockerhub