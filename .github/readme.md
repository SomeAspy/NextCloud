# EZ NextCloud

> NextCloud Config I use for my server

## The Intent

- Use NextCloud's fastest configs
- Easy to use
- Modular

## `config/config.env`

```env
### YOU SHOULD CHANGE THE FOLLOWING CONFIGS ###

# Trusted Domains (The domains NextCloud will be accessed from)
NEXTCLOUD_TRUSTED_DOMAINS=localhost

# Database Password
POSTGRES_PASSWORD=$0m3_R@nd0m_$+r1ng

### CONFIGS BELOW THIS LINE WILL WORK BY DEFAULT ###

# Database
POSTGRES_DB=nextcloud
POSTGRES_USER=nextcloud

# PHP
PHP_MEMORY_LIMIT=4096M

# Environment docs: https://hub.docker.com/_/nextcloud
```

## Included Scripts

- `fixIndexes.sh` - Fixes `The database is missing some indexes.`
- `maintenanceOff.sh` - Disables maintenance mode. (This commonly auto-enables after updates)
- `shell.sh` - Access the docker container's shell

## Adding to the base image

There are several reasons you may want to add to the base image. You can modify the base image by running extra commands using `config/dockerfile` with [standard dockerfile commands](https://docs.docker.com/engine/reference/builder/)

Included in the git repo is a dockerfile that will override the standard image to include bz2. Without this, you will get a notice in the NextCloud overview:
`This instance is missing some recommended PHP modules. For improved performance and better compatibility it is highly recommended to install them: bz2`

## FAQ

### I have warnings in the admin panel

There are a few warnings you will get with the default install using this configuration.

- `The reverse proxy header configuration is incorrect. This is a security issue and can allow an attacker to spoof their IP address as visible to the Nextcloud.`

- `The database is missing some indexes. Due to the fact that adding indexes on big tables could take some time they were not added automatically.`
- `Your installation has no default phone region set.`
