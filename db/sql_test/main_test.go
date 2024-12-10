package apollo

import (
	apollo "apollo/db/sqlc_gen"
	"database/sql"
	"log"
	"os"
	"testing"

	_ "github.com/lib/pq"
)

const (
	dbDriver = "postgres"
	dbSource = "postgres://root:root@localhost:5435/apollo_dev?sslmode=disable"
)

var testQueries *apollo.Queries

func TestMain(m *testing.M) {
	conn, err := sql.Open(dbDriver, dbSource)
	if err != nil {
		log.Fatalf("Cannot connect to database apollo")
	}

	testQueries = apollo.New(conn)

	os.Exit(m.Run())
}
