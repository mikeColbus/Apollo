DROP FUNCTION research.fn_list_company();
DROP FUNCTION research.fn_get_company(p_id integer);
DROP FUNCTION research.fn_ins_company(p_ct_id INT, pc_id INT, pc_name VARCHAR(255));
DROP FUNCTION research.fn_upd_company(p_company_id integer, p_company_type_id integer, p_parent_company_id integer, p_company_name VARCHAR(255));
DROP PROCEDURE research.fn_del_company(IN p_id integer);