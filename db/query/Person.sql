SET search_path TO research;

-- name: CreatePerson :one
SELECT * FROM research.fn_ins_person($1, $2, $3, $4);

-- name: UpdatePerson :one
SELECT * FROM research.fn_upd_person($1, $2, $3, $4, $5);

-- name: GetPerson :one
SELECT * FROM research.fn_get_person($1);

-- name: ListPerson :many
SELECT * FROM research.fn_list_person();

-- name: DeletePerson :exec
CALL research.fn_del_person($1);
