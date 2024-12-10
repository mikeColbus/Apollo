package apollo

import (
	apollo "apollo/db/sqlc_gen"
	"context"
	"database/sql"
	"errors"
	"github.com/go-faker/faker/v4"
	"github.com/stretchr/testify/require"
	"testing"
	"time"
)

// CreateRandomCompany generate a new random Company
func createRandomCompany(t *testing.T) apollo.ResearchCompany {
	arg := apollo.CreateCompanyTypeParams{
		PCompanyTypeName: faker.Name(),
		PDescription:     faker.Sentence(),
	}
	ct, err := testQueries.CreateCompanyType(context.Background(), arg)
	require.NoError(t, err)
	require.NotEmpty(t, ct)

	name := faker.DomainName() // Get Random domain name
	newC := apollo.CreateCompanyParams{
		PcID:           0,
		PcompanyTypeID: ct.CompanyTypeID,
		PcName:         name,
	}

	c, err := testQueries.CreateCompany(context.Background(), newC)
	require.NoError(t, err)
	require.NotEmpty(t, c)

	require.Equal(t, newC.PcName, c.CompanyName)
	require.Equal(t, newC.PcompanyTypeID, c.CompanyTypeID) // Type does not match
	require.Equal(t, newC.PcID, c.ParentCompanyID.Int32)

	require.NotZero(t, c.CompanyID)
	require.NotZero(t, c.CreatedAt)

	return c
}

// TestCreateCompanyType test CompanyType creation
func TestCreateCompany(t *testing.T) {
	_ = createRandomCompany(t)
	//deleteCompanyById(t, c.CompanyID)
}

func deleteCompanyById(t *testing.T, id int32) {
	err := testQueries.DeleteCompany(context.Background(), id)
	require.NoError(t, err)
}

func TestDeleteCompany(t *testing.T) {
	tempCompany := createRandomCompany(t)
	deleteCompanyById(t, tempCompany.CompanyID)
}

func TestGetCompany(t *testing.T) {
	tempCompany := createRandomCompany(t)

	company, err := testQueries.GetCompany(context.Background(), tempCompany.CompanyID)
	require.NoError(t, err)
	require.NotZero(t, company)

	require.Equal(t, tempCompany.CompanyTypeID, company.CompanyTypeID)
	require.Equal(t, tempCompany.ParentCompanyID, company.ParentCompanyID)
	require.True(t, tempCompany.CompanyName == company.CompanyName)

	require.WithinDuration(t, tempCompany.CreatedAt, company.CreatedAt, time.Second*60)

	deleteCompanyById(t, tempCompany.CompanyID)
}

func UpdateCompany(arg apollo.UpdateCompanyParams) (apollo.ResearchCompany, error) {

	company, err := testQueries.UpdateCompany(context.Background(), arg)
	return company, err
}

func TestUpdateCompanyNameError(t *testing.T) {
	tc := createRandomCompany(t)
	tc2 := createRandomCompany(t)

	companyArg := apollo.UpdateCompanyParams{
		PCompanyID:       tc.CompanyID,
		PCompanyTypeID:   tc.CompanyTypeID,
		PParentCompanyID: 0,
		PCompanyName:     tc2.CompanyName,
	}

	company, err := UpdateCompany(companyArg)

	require.Error(t, err)
	require.Zero(t, company)

	// Verify the error message
	expectedErr := "pq: duplicate key value violates unique constraint \"company_company_name_key\""
	if !errors.Is(err, sql.ErrNoRows) && err.Error() != expectedErr {
		t.Errorf("Expected error message: %v, but got: %v", expectedErr, err)
	}

	deleteCompanyById(t, companyArg.PCompanyID)
	deleteCompanyById(t, tc.CompanyID)
	deleteCompanyById(t, tc2.CompanyID)
}

func TestListCompanies(t *testing.T) {
	var lc apollo.ResearchCompany
	var ids []int32

	for i := 0; i < 10; i++ {
		lc = createRandomCompany(t)
		ids = append(ids, lc.CompanyID)
	}

	cts, err := testQueries.ListCompanies(context.Background())
	require.NoError(t, err)
	require.NotEmpty(t, cts)

	for _, company := range cts {
		require.NotEmpty(t, company)
	}

	for _, id := range ids {
		deleteCompanyById(t, id)
	}
}
