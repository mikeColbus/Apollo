SET search_path TO research;

-- name: CreateCompany :one
SELECT * FROM research.fn_ins_company($1, $2, $3);

-- name: UpdateCompany :one
SELECT * FROM research.fn_upd_company($1, $2, $3, $4);

-- name: GetCompany :one
SELECT * FROM research.fn_get_company($1);

-- name: ListCompanies :many
SELECT * FROM research.fn_list_company();

-- name: DeleteCompany :exec
CALL research.fn_del_company($1);

