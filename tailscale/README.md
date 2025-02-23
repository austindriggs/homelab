# TailScale

Today I setup [TailScale](https://tailscale.com/), and I've tried to keep track of passwords I've given out. Some important links for reading:
- [How it works](https://tailscale.com/blog/how-tailscale-works)
- [Why Tailscale](https://tailscale.com/why-tailscale)
- [Docs > Start > Quickstart](https://tailscale.com/kb/1017/install)
- [Use Cases - Homelab](https://tailscale.com/use-cases/homelab)

I entered my CasaOS terminal and entered the command: 
```bash
curl -fsSL https://tailscale.com/install.sh | sh
```

And then  followed the prompts.

Some important setup instructions
1. Login to TailScale using Google.
2. When prompted, select `myemail@gmail.com` as the mesh, do NOT select your google account you just used to sign in.
3. Use the CasaOS IP address (`000.000.000.000`) for most things, it is over HTTP.
