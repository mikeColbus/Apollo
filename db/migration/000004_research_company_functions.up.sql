SET search_path TO research;

--
-- Company
--
/*
        company_id serial PRIMARY KEY,
        company_type_id smallint,
        parent_company_id smallint,
        company_name varchar(255) UNIQUE NOT NULL,
        created_at timestamp NOT NULL DEFaULT 'now()'
*/

CREATE OR REPLACE FUNCTION research.fn_ins_company(
    pcompany_type_id INT,
    pc_id INT,
    pc_name VARCHAR(255)
) RETURNS SETOF research.company AS $$
DECLARE
    new_record research.company%ROWTYPE;
BEGIN

    IF EXISTS (SELECT 1 FROM research.tv_company_type WHERE company_type_id = pcompany_type_id) THEN
        --RAISE INFO "parent company type found";
        -- Check if the id exists
        IF EXISTS (SELECT 1 FROM research.tv_company WHERE company_id = pc_id) THEN
            -- Insert the new record
            INSERT INTO research.company (company_type_id, parent_company_id, company_name, created_at)
            VALUES (pcompany_type_id, pc_id, pc_name, NOW())
            RETURNING * INTO new_record;

        ELSE
            -- Force NULL for parent company id
            INSERT INTO research.company (company_type_id, parent_company_id, company_name, created_at)
            VALUES (pcompany_type_id, NULL, pc_name, NOW())
            RETURNING * INTO new_record;
        END IF;
    END IF;

    -- Return the newly inserted row
    RETURN NEXT new_record;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION research.fn_upd_company(
    p_company_id integer,
    p_company_type_id integer,
    p_parent_company_id integer,
    p_company_name character varying)
    RETURNS SETOF research.company AS $$
DECLARE
    v_company_record research.company%ROWTYPE;
BEGIN

    -- Step 1: Verify that company_id does not equal 0 or parent_company_id
    -- if either is true set p_parent_company_id to NULL
    IF p_parent_company_id = 0 OR p_company_id = p_parent_company_id THEN
        p_parent_company_id := NULL;  -- Use := for assignment
    END IF;

    -- Step 2: Update the company record if all conditions are verified
    RETURN QUERY
        UPDATE research.company AS rc
            SET
                company_type_id = p_company_type_id,
                parent_company_id = p_parent_company_id,
                company_name = p_company_name
            WHERE rc.company_id = p_company_id
            RETURNING rc.*;

END;
$$ LANGUAGE plpgsql;
/*
ALTER FUNCTION research.fn_upd_company(integer, integer, integer, character varying)
    OWNER TO root;
*/
CREATE OR REPLACE FUNCTION research.fn_get_company(p_id INT)
    RETURNS research.company
AS
$$
SELECT *
FROM research.tv_company AS c
WHERE c.company_id = p_id
$$
    LANGUAGE SQL;


CREATE OR REPLACE FUNCTION research.fn_list_company()
    RETURNS SETOF research.company
AS
$$
SELECT *
FROM research.tv_company AS ct
$$
    LANGUAGE SQL;


CREATE OR REPLACE PROCEDURE research.fn_del_company(p_id INT) AS $$
BEGIN
    -- Perform the delete operation
    DELETE FROM research.tv_company AS c
    WHERE c.company_id = p_id;

END;
$$ LANGUAGE plpgsql;