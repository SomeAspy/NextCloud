# EZ NextCloud

> NextCloud Config I use for my server

## The Intent

- Use NextCloud's fastest configs
- Easy to use
- Modular

## `config.env`

```env
# You should probably change this, but it will work as-is
POSTGRES_PASSWORD=$0m3_R@nd0m_$+r1ng

# These will work as is, but you can change them.
POSTGRES_DB=nextcloud
POSTGRES_USER=nextcloud
```

## Included Scripts

- `maintenanceOff.sh` - Disables maintenance mode. (This commonly auto-enables after updates)
- `shell.sh` - Access the docker container's shell

## Adding to the base image

There are several reasons you may want to add to the base image. This can be done by creating the `overrides` folder and putting a `dockerfile` inside of it
You will want to start the dockerfile with the following:

```dockerfile
FROM: nextcloud:fpm-alpine
```

From there you can extend the image using [standard dockerfile commands](https://docs.docker.com/engine/reference/builder/)
