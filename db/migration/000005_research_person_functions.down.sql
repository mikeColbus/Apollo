DROP FUNCTION research.fn_list_person();
DROP FUNCTION research.fn_get_person(p_id integer);
DROP FUNCTION research.fn_ins_person(p_first_name VARCHAR(50), p_last_name VARCHAR(50), p_Primary_phone VARCHAR(15),
                                     p_primary_email VARCHAR(100));
DROP FUNCTION research.fn_upd_person(p_person_id integer, p_first_name VARCHAR(50), p_last_name VARCHAR(50),
                                     p_Primary_phone VARCHAR(15), p_primary_email VARCHAR(100));
DROP PROCEDURE research.fn_del_person(IN p_id integer);