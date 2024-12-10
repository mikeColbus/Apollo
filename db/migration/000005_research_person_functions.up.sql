SET search_path TO research;

--
-- Person
--
/*
      person_id serial PRIMARY KEY,
      first_name varchar(50) NOT NULL,
      last_name varchar(50) NOT NULL,
      PRIMARY_phone varchar(15) UNIQUE NOT NULL,
      PRIMARY_email varchar(100) NOT NULL,
      created_at timestamp NOT NULL DEFaULT 'now()'
*/

CREATE OR REPLACE PROCEDURE research.fn_del_person(p_id INT) AS $$
BEGIN
    -- Perform the delete operation
    DELETE FROM research.tv_person AS p
    WHERE p.person_id = p_id;

END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION research.fn_list_person()
    RETURNS SETOF research.person
AS
$$
SELECT *
FROM research.tv_person AS p
$$
    LANGUAGE SQL;


CREATE OR REPLACE FUNCTION research.fn_get_person(p_id INT)
    RETURNS research.person
AS
$$
SELECT *
FROM research.tv_person AS p
WHERE p.person_id = p_id
$$
    LANGUAGE SQL;


CREATE OR REPLACE FUNCTION research.fn_upd_person(
    p_person_id INT,
    p_first_name VARCHAR(50),
    p_last_name VARCHAR(50),
    p_Primary_phone VARCHAR(15),
    p_primary_email VARCHAR(100)
)
    RETURNS research.person AS $$

UPDATE research.tv_person SET first_name = p_first_name,
                              last_name = p_last_name,
                              primary_phone = p_Primary_phone,
                              primary_email = p_primary_email,
                              created_at = NOW()
WHERE person_id = p_person_id
RETURNING person_id, first_name, last_name, primary_phone, primary_email, created_at;

$$
    LANGUAGE SQL;


CREATE OR REPLACE FUNCTION research.fn_ins_person(
    p_first_name VARCHAR(50),
    p_last_name VARCHAR(50),
    p_primary_phone VARCHAR(15),
    p_primary_email VARCHAR(100)
) RETURNS SETOF research.person AS $$
DECLARE
    new_record research.person%ROWTYPE;
BEGIN
    -- Perform the insert operation
    INSERT INTO research.person (first_name, last_name, Primary_phone,
                                 primary_email, created_at)
    VALUES (p_first_name, p_last_name, p_primary_phone, p_primary_email, NOW())
    RETURNING * INTO new_record;

    -- Return the newly inserted row
    RETURN NEXT new_record;
END;
$$ LANGUAGE plpgsql;
