# Manual container on Linux

Containers (Linux containers) are basically isolated processes that embrace namespaces, cgroups, layered file system and Linux chroot magic

## Setup

Every exercise requires to:
* Launch docker image:
  * cd into */manual-linux-container* of this repository
  * execute *docker run -it --name docker-host --rm --privileged --mount type=bind,source="$(pwd)",target=/mnt/host ubuntu:jammy*, meaning:
      * **-i -t** flags - allow for tty interaction and open connection
      * **--name docker-host** - name of the container
      * **--rm** - cleans container on exit
      * **--privileged** - for sake of excersise allows extended priviledges
      * **--mount type=bind,source="$(pwd)",target=/mnt/host** - binds pwd (thus cd earlier) into */mnt/host* dir in container
      * **pwd** - process working directory, i did this exercise on WSL2 if ur on windows it would be %cd% i suppouse
* Container tty should open, execute *cd /mnt/host/manual-linux-container*, from there you can do exercises from below


## Chroot

* Execute */dir-with-execs.sh somedir "bash ls"* - it creates directory with executables (this case bash and ls) and their library dependencies
* Now execute *chroot somedir bash* - it opens bash as process that treats our somedir as system root directory:
    * You can try go lower with *cd ..* but it won't happen
    * It also has ls we provided by executing *dir-with-execs.sh* earlier

## Namespaces

* If previous exercise was completed we can check:
    * We can't access file system below
    * We still can access, for example all processes running on main linux container (one w launched with docker) and still cause damage (with kill)

To help resolve this issue we can unshare resources:
* Launch *./debian-setup.sh /db_namespaces*, it will set up Debian distro in provided directory (db_namespaces this case)
* We, recreating in system root because in my case I don't want to deal with exec and mount privleges on our mounted directory
* Configure out namespaced, chrooted system:
    * *unshare --mount --uts --ipc --net --pid --fork --user --map-root-user chroot /db_namespaces bash* - it will head us into new isolated debian system and launch bash
    * Basically all flags are some type of isolation for our new environment
    * Mount:
      * *mount -t proc none /proc* - mounts kernel data structures (could not be mounted automatically)
      * *mount -t sysfs none /sys* - mounts filesystem
      * *mount -t tmpfs none /tmp* - mounts temporary file system
* Now try to kill some pid from main container, it shouldn't work, process should be treated as nonexistent in our namespaced chroot

## Cgroups

For this exercise cgroup2 is required, to enable it on WSL you have to add
```
[wsl2]
kernelCommandLine = cgroup_no_v1=all
```
into your .wslconfig file.

If command *mount | grep cgroup* returns *cgroup on /sys/fs/cgroup type cgroup2 (rw,nosuid,nodev,noexec,relatime)* it means it worked.

So, steps are:
* First it's good to install htop - *apt-get install htop* - it will allow as to monitor resources consumption
* Then we want to open 2 other terminals with *docker exec -it docker-host bash*
* In one of them we can run *htop* - this one will act as our monitor
* In second we run our unshared environment from namespaces section and run *yes | tr \\n x | head -c 1048576000 | grep n*, this will increase our cpu and ram consumption a lot, look at our monitor terminal
* So to configure cgroups run *./configure-cgroups.sh*, what it does it creates cgroup for parent tasks, moves every process from main cgroup there and adds controllers available for custom cgroups
* To prevent this we can create cgroup, lets name it db_namespace as well. To do this we run *mkdir /sys/fs/cgroup/db_namespace*. If we *ls* our new dir we can see a lot of files responsible for processes resource control.
* Let's set max memory level for this group to 300MB RAM, to do this we execute *echo 314572800 > /sys/fs/cgroup/db_namespace/memory.max*
* See that out chrooted environment doesn't exceed indicated level



