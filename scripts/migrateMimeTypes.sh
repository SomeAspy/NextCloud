#!/bin/sh
docker compose exec -u www-data app php occ maintenance:repair --include-expensive