#!/bin/sh
docker compose exec -u www-data app php occ db:add-missing-indices