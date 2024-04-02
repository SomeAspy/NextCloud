# EZ NextCloud

> NextCloud Config I use for my server

## The Intent

- Use NextCloud's fastest configs
- Easy to use
- Modular

> [!IMPORTANT]  
> Do not open issues without first reading the entirety of this readme, especially [the FAQ](#faq). You should also consider checking [the NextCloud docs](https://docs.nextcloud.com/server/latest/admin_manual/)

## `example.env`

> This is an example file and it will not be read. You should copy it to `.env` and make applicable changes there.

```env
### YOU SHOULD CHANGE THE FOLLOWING CONFIGS ###

# Trusted Domains (The domains NextCloud will be accessed from)
NEXTCLOUD_TRUSTED_DOMAINS=localhost

# Database Password
POSTGRES_PASSWORD=$0m3_R@nd0m_$+r1ng

### CONFIGS BELOW THIS LINE WILL WORK BY DEFAULT ###

# Volume locations

DATA_VOLUME=./volumes/nextcloud/data
CONFIG_VOLUME=./volumes/nextcloud/config
THEME_VOLUME=./volumes/nextcloud/themes
APP_VOLUME=./volumes/nextcloud/apps
WEB_VOLUME=./volumes/nextcloud/web

# Database
POSTGRES_DB=nextcloud
POSTGRES_USER=nextcloud

# PHP
PHP_MEMORY_LIMIT=4096M

# PROXY
SERVE_PORT=80

# Environment docs: https://hub.docker.com/_/nextcloud
```

## Post Install

After the first run, you should do the following:

- In `Administration>Basic Settings` you should set `Background jobs` to run using `Cron (Recommended)`. This will ensure background tasks will run regardless of the frontend being used.
- In `Administration>Overview` you should review all error and warnings under `Security & setup warnings`. You can view how to fix some common ones in the [warnings FAQ](#i-have-warnings-in-the-admin-panel). The default install generally will have some issues.

## Included Scripts

- `fixIndexes.sh` - Fixes `The database is missing some indexes.`
- `maintenanceOff.sh` - Disables maintenance mode. (This commonly auto-enables after updates)
- `shell.sh` - Access the docker container's shell
- `update.sh` - Pull and build images

## Adding to the base image

There are several reasons you may want to add to the base image. You can modify the base image by running extra commands using `config/dockerfile` with [standard dockerfile commands](https://docs.docker.com/engine/reference/builder/)

Included in the git repo is a dockerfile that will override the standard image to include bz2. Without this, you will get a notice in the NextCloud overview:
`This instance is missing some recommended PHP modules. For improved performance and better compatibility it is highly recommended to install them: bz2`

## Notable Changes

- Config files are only applied at container start. This is an optimization from the [NextCloud tuning guide.](https://docs.nextcloud.com/server/latest/admin_manual/installation/server_tuning.html#tune-php-fpm) (Specifically `opcache.revalidate_freq = 0` in [the `php.ini` file](../config/php.ini))

- Instead of using Redis for caching, [Dragonfly](https://github.com/dragonflydb/dragonfly) is used.

## FAQ

> [!NOTE]  
> Anything involving a change under `./volumes/*` will require the containers to have been run at least once, as the `volumes` folder is only generated on first run.

### I want to use a different storage location

> [!CAUTION]
> This should be done BEFORE you run the container for the first time. Otherwise, NextCloud will be confused and try to reinstall.

**Solution:** In [`docker-compose.yml`](../docker-compose.yml) under `app` and `volumes` replace `./volumes/nextcloud/data:/var/www/html/data` with `/path/to/data:/var/www/html/data`. ***The second part after the colon should always be the same***

---

### I get warnings from docker saying `x variable is not set.`

**Solution:** Ensure you copied [`example.env`](../example.env) to `.env` in the head of the repository and looked over the config.

---

### I have warnings in the admin panel

There are a few warnings you will get with the default install using this configuration.

#### The reverse proxy header configuration is incorrect. This is a security issue and can allow an attacker to spoof their IP address as visible to the Nextcloud

**Solution:** Add `'trusted_proxies' => array('localhost'),` to `volumes/nextcloud/config/config.php`.

#### The database is missing some indexes. Due to the fact that adding indexes on big tables could take some time they were not added automatically

**Solution:** Run `bash config/fixIndexes.sh`

#### Your installation has no default phone region set

**Solution:** Add `'default_phone_region' => 'US',` to `volumes/nextcloud/config/config.php`. Replace `US` with your country's corresponding [ISO 3166-1 Alpha-2 code](https://en.wikipedia.org/wiki/ISO_3166-1#Codes)

#### You are accessing your instance over a secure connection, however your instance is generating insecure URLs

**Solution:** Add `'overwriteprotocol' => 'https',` to `volumes/nextcloud/config/config.php`.

#### Server has no maintenance window start time configured

**Solution:** Add `'maintenance_window_start' => 1,` to `volumes/nextcloud/config/config.php`. Set this to a time that is best for you. [Documentation](https://docs.nextcloud.com/server/28/admin_manual/configuration_server/background_jobs_configuration.html)

#### `X` error(s) in the logs since `Y`

**Solution:** With a proper setup, this should resolve itself over time, and if it does not, you can check `Administration>Logging`.
> [!IMPORTANT]  
> If something seems abnormal, make sure you read over the FAQ in it's entirety, as well as referring to [the NextCloud docs](https://docs.nextcloud.com/server/latest/admin_manual/). Consider opening an issue if you believe it is directly related to this config.

#### You have not set or verified your email server configuration, yet

**Solution:** Setup and send the test email ([NextCloud Email Documentation](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/email_configuration.html))
