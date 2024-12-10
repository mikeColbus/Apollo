SET search_path TO research;


CREATE OR REPLACE FUNCTION research.fn_ins_company_type(
    p_company_type_name VARCHAR(50),
    p_description TEXT
) RETURNS SETOF research.company_type AS $$
DECLARE
    new_record research.company_type%ROWTYPE;
BEGIN
    -- Perform the insert operation
    INSERT INTO research.company_type (company_type_name, description, created_at)
    VALUES (p_company_type_name, p_description, NOW())
    RETURNING * INTO new_record;

    -- Return the newly inserted row
    RETURN NEXT new_record;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION research.fn_get_company_type(p_id INT)
    RETURNS research.company_type
AS
$$
SELECT *
FROM research.tv_company_type AS ct
WHERE ct.company_type_id = p_id
$$
    LANGUAGE SQL;


CREATE OR REPLACE FUNCTION research.fn_list_company_type()
    RETURNS SETOF research.company_type
AS
$$
SELECT *
FROM research.tv_company_type AS ct
$$
    LANGUAGE SQL;


CREATE OR REPLACE FUNCTION research.fn_upd_company_type(p_id integer, p_name varchar(50), p_desc text)
    RETURNS research.company_type
AS
$$

UPDATE research.tv_company_type SET company_type_name = p_name, description = p_desc
WHERE company_type_id = p_id
RETURNING company_type_id, company_type_name, description, created_at;

$$
    LANGUAGE SQL;


CREATE OR REPLACE PROCEDURE research.fn_del_company_type(
    p_id INT
) AS $$
BEGIN
    -- Perform the delete operation
    DELETE FROM research.company_type
    WHERE company_type_id = p_id;

END;
$$ LANGUAGE plpgsql;




