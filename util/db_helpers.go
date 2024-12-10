package util

import "database/sql"

func compareStringAndNullString(str string, nullStr sql.NullString) bool {
	// Check if the sql.NullString is valid (not null)
	if nullStr.Valid {
		// Compare the regular string with the String field of sql.NullString
		return str == nullStr.String
	}
	// Handle the case where sql.NullString is null (Valid is false)
	// Depending on your logic, you might consider this case false or handle it differently.
	return false
}
