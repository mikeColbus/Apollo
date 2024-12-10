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

// createRandomCompanyType generate a new random Company_Type
func createRandomCompanyType(t *testing.T) apollo.ResearchCompanyType {

	name := faker.DomainName() // Get Random domain name
	arg := apollo.CreateCompanyTypeParams{
		PCompanyTypeName: name,
		PDescription:     name + " - " + faker.Paragraph(),
	}

	companyType, err := testQueries.CreateCompanyType(context.Background(), arg)
	require.NoError(t, err)
	require.NotEmpty(t, companyType)

	require.Equal(t, arg.PCompanyTypeName, companyType.CompanyTypeName)
	require.Equal(t, arg.PDescription, companyType.Description.String)

	require.NotZero(t, companyType.CompanyTypeID)
	require.NotZero(t, companyType.CreatedAt)

	return companyType
}

// TestCreateCompanyType test CompanyType creation
func TestCreateCompanyType(t *testing.T) {
	tempCompanyType := createRandomCompanyType(t)
	DeleteCompanyTypeById(t, tempCompanyType.CompanyTypeID)
}

// DeleteCompanyTypeById removes a CompanyType from the database if its ID exists
func DeleteCompanyTypeById(t *testing.T, id int32) {
	err := testQueries.DeleteCompanyType(context.Background(), id)
	require.NoError(t, err)
}

func TestDeleteCompanyTypeTest(t *testing.T) {
	tempCompanyType := createRandomCompanyType(t)
	DeleteCompanyTypeById(t, tempCompanyType.CompanyTypeID)
}

// TestGetCompanyType tests getting an CompanyType by ID
func TestGetCompanyType(t *testing.T) {
	tempCompanyType := createRandomCompanyType(t)

	companyType, err := testQueries.GetCompanyType(context.Background(), tempCompanyType.CompanyTypeID)
	require.NoError(t, err)
	require.NotZero(t, companyType)

	require.Equal(t, tempCompanyType.CompanyTypeID, companyType.CompanyTypeID)
	require.Equal(t, tempCompanyType.CompanyTypeName, companyType.CompanyTypeName)
	require.True(t, tempCompanyType.Description == companyType.Description)
	require.WithinDuration(t, tempCompanyType.CreatedAt, companyType.CreatedAt, time.Second*60)

	DeleteCompanyTypeById(t, tempCompanyType.CompanyTypeID)
}

func UpdateCompanyType(t *testing.T, arg apollo.UpdateCompanyTypeParams) (apollo.ResearchCompanyType, error) {
	companyType, err := testQueries.UpdateCompanyType(context.Background(), arg)
	return companyType, err
}

func TestUpdateCompanyTypeDescriptionChange(t *testing.T) {
	tempCompanyType := createRandomCompanyType(t)

	arg := apollo.UpdateCompanyTypeParams{
		PID:   tempCompanyType.CompanyTypeID,
		PName: tempCompanyType.CompanyTypeName,
		PDesc: faker.Paragraph(),
	}
	// U
	updCompanyType, err := UpdateCompanyType(t, arg)
	require.NoError(t, err)
	require.NotZero(t, updCompanyType)

	require.Equal(t, tempCompanyType.CompanyTypeID, updCompanyType.CompanyTypeID)
	require.Equal(t, tempCompanyType.CompanyTypeName, updCompanyType.CompanyTypeName)
	require.NotEqual(t, tempCompanyType.Description, updCompanyType.Description) // Description update should be different
	require.WithinDuration(t, tempCompanyType.CreatedAt, updCompanyType.CreatedAt, time.Second*60)

	// Remove created CompanyType records
	DeleteCompanyTypeById(t, tempCompanyType.CompanyTypeID)
}

func TestUpdateCompanyTypeDupNameError(t *testing.T) {
	baseCompanyType := createRandomCompanyType(t)
	testCompanyType := createRandomCompanyType(t)

	arg := apollo.UpdateCompanyTypeParams{
		PID:   testCompanyType.CompanyTypeID,
		PName: baseCompanyType.CompanyTypeName, // Try to Update Name to existing Name - Error Expected UniqueError
		PDesc: testCompanyType.Description.String,
	}

	updCompanyType, err := UpdateCompanyType(t, arg)
	require.Error(t, err)
	require.Zero(t, updCompanyType)

	// Verify the error message
	expectedErr := "pq: duplicate key value violates unique constraint \"company_type_company_type_name_key\""
	if !errors.Is(err, sql.ErrNoRows) && err.Error() != expectedErr {
		t.Errorf("Expected error message: %v, but got: %v", expectedErr, err)
	}

	// Remove created CompanyType records
	DeleteCompanyTypeById(t, baseCompanyType.CompanyTypeID)
	DeleteCompanyTypeById(t, baseCompanyType.CompanyTypeID)
}

func TestListCompanyTypes(t *testing.T) {
	var lastCompanyType apollo.ResearchCompanyType
	var ids []int32

	for i := 0; i < 10; i++ {
		lastCompanyType = createRandomCompanyType(t)
		ids = append(ids, lastCompanyType.CompanyTypeID)
	}

	CompanyTypes, err := testQueries.ListCompanyTypes(context.Background())
	require.NoError(t, err)
	require.NotEmpty(t, CompanyTypes)

	for _, CompanyType := range CompanyTypes {
		require.NotEmpty(t, CompanyType)
	}

	for _, id := range ids {
		DeleteCompanyTypeById(t, id)
	}
}
