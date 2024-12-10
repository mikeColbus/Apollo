SET search_path TO research;

-- name: CreateCompanyType :one
SELECT * FROM research.fn_ins_company_type($1, $2);

-- name: UpdateCompanyType :one
SELECT * FROM research.fn_upd_company_type($1, $2, $3);

-- name: GetCompanyType :one
SELECT * FROM research.fn_get_company_type($1);

-- name: ListCompanyTypes :many
SELECT * FROM research.fn_list_company_type();

-- name: DeleteCompanyType :exec
CALL research.fn_del_company_type($1);
