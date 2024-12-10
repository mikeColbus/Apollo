DROP FUNCTION research.fn_list_company_type();
DROP FUNCTION research.fn_get_company_type(p_id integer);
DROP FUNCTION research.fn_ins_company_type(p_name varchar(50), p_desc text);
DROP FUNCTION research.fn_upd_company_type(p_id integer, p_name varchar(50), p_desc text);
DROP PROCEDURE research.fn_del_company_type(IN p_id integer);