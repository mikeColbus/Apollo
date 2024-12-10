CREATE OR REPLACE VIEW research.tv_company_type(company_type_id, company_type_name, description, created_at) AS
SELECT company_type_id,
       company_type_name,
       description,
       created_at
FROM research.company_type;

ALTER TABLE research.tv_company_type
    owner to root;

CREATE OR REPLACE VIEW research.tv_company(company_id, company_type_id, parent_company_id, company_name, created_at) AS
SELECT company_id,
       company_type_id,
       parent_company_id,
       company_name,
       created_at
FROM research.company;

ALTER TABLE research.tv_company
    owner to root;

CREATE OR REPLACE VIEW research.tv_research_category(research_category_id, research_category_name, description, created_at) AS
SELECT research_category_id,
       research_category_name,
       description,
       created_at
FROM research.research_category;

ALTER TABLE research.tv_research_category
    owner to root;

CREATE OR REPLACE VIEW research.tv_company_research_category(research_category_id, company_id, created_at) AS
SELECT research_category_id,
       company_id,
       created_at
FROM research.company_research_category;

ALTER TABLE research.tv_company_research_category
    owner to root;

CREATE OR REPLACE VIEW research.tv_person(person_id, first_name, last_name, primary_phone, primary_email, created_at) AS
SELECT person_id,
       first_name,
       last_name,
       primary_phone,
       primary_email,
       created_at
FROM research.person;

ALTER TABLE research.tv_person
    owner to root;

CREATE OR REPLACE VIEW research.tv_company_person(company_person_id, company_id, person_id, title, email, created_at) AS
SELECT company_person_id,
       company_id,
       person_id,
       title,
       email,
       created_at
FROM research.company_person;

ALTER TABLE research.tv_company_person
    owner to root;

CREATE OR REPLACE VIEW research.vw_company_research_category
            (research_category_id, company_id, company_name, research_category_name, created_at) AS
SELECT crc.research_category_id,
       crc.company_id,
       c.company_name,
       rc.research_category_name,
       crc.created_at
FROM research.tv_company_research_category crc,
     research.tv_company c,
     research.tv_research_category rc
WHERE crc.company_id = c.company_id
  AND crc.research_category_id = rc.research_category_id;

ALTER TABLE research.vw_company_research_category
    owner to root;

CREATE OR REPLACE VIEW research.vw_company_person_detail
            (company_person_id, company_id, company_name, person_id, first_name, last_name, title, email, created_at) AS
SELECT cp.company_person_id,
       cp.company_id,
       c.company_name,
       cp.person_id,
       p.first_name,
       p.last_name,
       cp.title,
       cp.email,
       cp.created_at
FROM research.tv_company_person cp,
     research.tv_company c,
     research.tv_Person p
WHERE cp.company_id = c.company_id
  AND cp.person_id = p.person_id;

ALTER TABLE research.vw_company_person_detail
    owner to root;
