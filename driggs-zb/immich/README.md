# Immich


## Setup

I installed using their instructions at: https://immich.app/docs/install/portainer. Also see:
- [my FINAL pick for a self-hosted photo server - immich](https://youtu.be/s1ufPvO0BVE?si=JrExTVNUj2ICqVRa) by [TechHut](https://www.youtube.com/@TechHut)
- [Louis Rossmann Shows You How to Install Immich](https://youtu.be/HxNOgKeIiDY?si=59dKuep8-htdUofG) by [FUTO](https://www.youtube.com/@FUTOTECH)

I then created a second instance of everything, renaming all the containers with `<name>-parents` so there's no conflicts, and mapped it to port 8019 instead of 8013.


## Google Takeout

I got all my photos from 2004-2024 through Google Takeout. This split up all my `pictures.jpg` from there `metadata.json`, which is extremely annoying. Luckily, someone has come up with a solution to this: [Google Photos Takeout Helper](https://github.com/TheLastGimbus/GooglePhotosTakeoutHelper) by TheLastGimbus on GitHub.

I downloaded the latest release for linux, moved it to my temporary takeout folder:
```bash
driggs@driggs-HP-PD:~/Sandbox/immich$ ls -al
total 7780
drwxrwxr-x  3 driggs driggs    4096 Apr  9 21:44 .
drwxrwxr-x  5 driggs driggs    4096 Apr  9 21:38 ..
-rw-rw-r--  1 driggs driggs 7952232 Apr  9 21:38 gpth-linux
drwxrwxr-x 20 driggs driggs    4096 Apr  6 16:38 photos_through_2024
driggs@driggs-HP-PD:~/Sandbox/immich$ ls photos_through_2024/
2005  2009  2011  2013  2015  2017  2019  2021  2023
2006  2010  2012  2014  2016  2018  2020  2022  2024
```

Then give `gpth-linux` permissions:
```bash
chmod +x gpth-linux
```

Run it, and follow the prompted instructions:
```bash
./gpth-linux
```







## Parents

I created a second instance of Immich (for now) where I uploaded my parents photos on port 8019. I added an External Library with `parents` owner and let the jobs run for a while. 
