postgres:
	docker run --name apollo_postgres -p 5435:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=root -d postgres

apollo_start:
	docker run apollo_postgres

apollo_stop:
	docker stop apollo_postgres

createdb:
	docker exec -it apollo_postgres createdb --username=root --owner=root apollo_dev

dropdb:
	docker exec -it apollo_postgres dropdb -f apollo_dev

recreatedb:
	docker exec -it apollo_postgres dropdb -f apollo_dev
	docker exec -it apollo_postgres createdb --username=root --owner=root apollo_dev
	migrate -path db/migration -database "postgres://root:root@localhost:5435/apollo_dev?sslmode=disable" -verbose up

migrateup:
	migrate -path db/migration -database "postgres://root:root@localhost:5435/apollo_dev?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgres://root:root@localhost:5435/apollo_dev?sslmode=disable" -verbose down

cleantest:
	go clean -testcache

test:
	make cleantest
	go test -v -cover ./...

testdbug:
	make cleantest
	go test -v -cover -pdb ./...

sqlc:
	sqlc compile
	sqlc generate

-PHONY: postgres apollo_start apollo_stop createdb dropdb migrateup migratedown sqlc test testdbug cleantest recreatedb