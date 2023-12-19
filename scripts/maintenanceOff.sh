#!/bin/sh
docker compose exec -u www-data app php occ maintenance:mode --off