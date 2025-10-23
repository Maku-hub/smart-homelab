docker compose --file nginx-compose.yml up -d
docker compose --file nginx-compose.yml down

docker compose --file nginx-compose.yml exec nginx nginx -t
docker compose --file nginx-compose.yml exec nginx nginx -s reload
