CREATE SCHEMA IF NOT EXISTS research;
CREATE SCHEMA IF NOT EXISTS project;
CREATE SCHEMA IF NOT EXISTS algorithm;

CREATE TABLE IF NOT EXISTS research.company (
                           company_id serial PRIMARY KEY,
                           company_type_id integer NOT NULL,
                           parent_company_id integer REFERENCES research.company(company_id), -- Self-referencing foreign key
                           company_name varchar(255) UNIQUE NOT NULL,
                           created_at timestamp NOT NULL DEFaULT 'now()'
);

CREATE TABLE IF NOT EXISTS research.company_type (
                                company_type_id serial PRIMARY KEY,
                                company_type_name varchar(50) UNIQUE NOT NULL,
                                description text,
                                created_at timestamp NOT NULL DEFaULT 'now()'
);

CREATE TABLE IF NOT EXISTS research.company_person (
                                  company_person_id serial PRIMARY KEY,
                                  company_id integer,
                                  person_id integer,
                                  title varchar(50),
                                  email varchar(75) UNIQUE NOT NULL,
                                  created_at timestamp NOT NULL DEFaULT 'now()'
);

CREATE TABLE IF NOT EXISTS research.research_category (
                                     research_category_id serial PRIMARY KEY,
                                     research_category_name varchar(50) NOT NULL,
                                     description text,
                                     created_at timestamp NOT NULL DEFaULT 'now()'
);

CREATE TABLE IF NOT EXISTS research.company_research_category (
                                            company_research_category_id serial PRIMARY KEY,
                                            company_id integer,
                                            research_category_id integer,
                                            created_at timestamp NOT NULL DEFaULT 'now()'
);

CREATE TABLE IF NOT EXISTS project.project (
                           project_id serial PRIMARY KEY,
                           company_research_category_id integer,
                           project_name varchar(255) NOT NULL,
                           description text,
                           created_at timestamp NOT NULL DEFaULT 'now()'
);

CREATE TABLE IF NOT EXISTS project.project_person (
                                  project_id serial,
                                  person_id integer,
                                  project_role varchar(50),
                                  PRIMARY KEY (project_id, person_id)
);

CREATE TABLE IF NOT EXISTS project.analysis (
                            analysis_id serial PRIMARY KEY,
                            project_id int,
                            analysis_name varchar(255) NOT NULL,
                            description text,
                            created_at timestamp NOT NULL DEFaULT 'now()'
);

CREATE TABLE IF NOT EXISTS project.dataset (
                           dataset_id serial PRIMARY KEY,
                           file_path varchar(255) NOT NULL,
                           file_name varchar(255) UNIQUE NOT NULL,
                           prepared bool DEFaULT false,
                           created_at timestamp NOT NULL DEFaULT 'now()'
);

CREATE TABLE IF NOT EXISTS project.dataset_column (
                                  dataset_column_id serial PRIMARY KEY,
                                  dataset_id integer,
                                  original_column_name varchar(255) NOT NULL,
                                  reference_name varchar(255) NOT NULL,
                                  created_at timestamp NOT NULL DEFaULT 'now()'
);

CREATE TABLE IF NOT EXISTS project.analysis_configuration (
                                          analysis_id int PRIMARY KEY,
                                          algorithm_mask_id integer,
                                          dataset_id integer,
                                          outcome_column_id integer,
                                          operator_set_id integer,
                                          key_value_id integer,
                                          base_id integer,
                                          min_cache integer,
                                          max_cache integer,
                                          min_heat_map integer,
                                          max_heat_map integer,
                                          recombination_percent integer,
                                          holdout_percent integer,
                                          min_population integer,
                                          max_population integer,
                                          over_population_cycles integer,
                                          created_at timestamp NOT NULL DEFaULT 'now()'
);

CREATE TABLE IF NOT EXISTS project.algorithm_mask (
                                  algorithm_mask_id serial PRIMARY KEY,
                                  created_at timestamp NOT NULL DEFaULT 'now()'
);

CREATE TABLE IF NOT EXISTS project.base (
                        base_id serial PRIMARY KEY,
                        base_number integer,
                        base_name varchar(100),
                        description text,
                        delimiter varchar(1) DEFaULT ':',
                        created_at timestamp NOT NULL DEFaULT 'now()'
);

CREATE TABLE IF NOT EXISTS project.base_index (
                              base_id integer,
                              index integer,
                              value char(1),
                              created_at timestamp NOT NULL DEFaULT 'now()',
                              PRIMARY KEY (base_id, index)
);

CREATE TABLE IF NOT EXISTS project.operator_set (
                                operator_set_id serial PRIMARY KEY,
                                operator_set_name varchar(255) UNIQUE NOT NULL,
                                description text,
                                created_at timestamp NOT NULL DEFaULT 'now()'
);

CREATE TABLE IF NOT EXISTS project.operator (
                            operator_id serial PRIMARY KEY,
                            operator_code varchar(10) UNIQUE NOT NULL,
                            operator_name varchar(255) NOT NULL,
                            description text NOT NULL,
                            operand_count integer NOT NULL,
                            pattern varchar(255) NOT NULL,
                            created_at timestamp NOT NULL DEFaULT 'now()'
);

CREATE TABLE IF NOT EXISTS project.operator_set_operator (
                                         operator_set_id integer,
                                         operator_id integer
);

CREATE TABLE IF NOT EXISTS project.key_value_set (
                                 key_value_set_id serial PRIMARY KEY,
                                 key_value_set_name varchar(255) NOT NULL,
                                 description text,
                                 key_value_group_limit integer DEFaULT 0,
                                 created_at timestamp NOT NULL DEFaULT 'now()'
);

CREATE TABLE IF NOT EXISTS project.key_value_set_values (
                                        key_value_set_id integer,
                                        key_value_id integer,
                                        PRIMARY KEY (key_value_set_id, key_value_id)
);

CREATE TABLE IF NOT EXISTS project.key_value (
                             key_value_id serial PRIMARY KEY,
                             key_value_name varchar(255) NOT NULL,
                             description text,
                             csv_list varchar(255) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS research.person (
                          person_id serial PRIMARY KEY,
                          first_name varchar(50) NOT NULL,
                          last_name varchar(50) NOT NULL,
                          primary_phone varchar(15) UNIQUE NOT NULL,
                          primary_email varchar(100) NOT NULL,
                          created_at timestamp NOT NULL DEFaULT 'now()'
);

CREATE INDEX ON research.company (company_type_id);

CREATE INDEX ON research.company (parent_company_id);

CREATE INDEX ON research.company_research_category (company_id);

CREATE INDEX ON research.company_research_category (research_category_id);

CREATE INDEX ON research.company_research_category (company_id, research_category_id);

CREATE INDEX ON project.project (company_research_category_id);

CREATE INDEX ON project.analysis (project_id);

CREATE INDEX ON project.dataset (file_name);

CREATE INDEX ON project.dataset_column (dataset_id);

COMMENT ON TABLE project.project IS 'projects are one or more analysis efforts''';

ALTER TABLE research.company ADD FOREIGN KEY (company_type_id) REFERENCES research.company_type (company_type_id);

ALTER TABLE research.company_person ADD FOREIGN KEY (company_id) REFERENCES research.company (company_id);

ALTER TABLE research.company_person ADD FOREIGN KEY (person_id) REFERENCES research.person (person_id);

ALTER TABLE research.company_research_category ADD FOREIGN KEY (company_id) REFERENCES research.company (company_id);

ALTER TABLE research.company_research_category ADD FOREIGN KEY (research_category_id) REFERENCES research.research_category (research_category_id);

ALTER TABLE project.project ADD FOREIGN KEY (company_research_category_id) REFERENCES research.company_research_category (company_research_category_id);

ALTER TABLE project.project_person ADD FOREIGN KEY (project_id) REFERENCES project.project (project_id);

ALTER TABLE project.project_person ADD FOREIGN KEY (person_id) REFERENCES research.person (person_id);

ALTER TABLE project.analysis ADD FOREIGN KEY (project_id) REFERENCES project.project (project_id);

ALTER TABLE project.dataset_column ADD FOREIGN KEY (dataset_id) REFERENCES project.dataset (dataset_id);

ALTER TABLE project.analysis_configuration ADD FOREIGN KEY (analysis_id) REFERENCES project.analysis (analysis_id);

ALTER TABLE project.analysis_configuration ADD FOREIGN KEY (algorithm_mask_id) REFERENCES project.algorithm_mask (algorithm_mask_id);

ALTER TABLE project.analysis_configuration ADD FOREIGN KEY (outcome_column_id) REFERENCES project.dataset_column (dataset_column_id);

ALTER TABLE project.analysis_configuration ADD FOREIGN KEY (dataset_id) REFERENCES project.dataset (dataset_id);

ALTER TABLE project.analysis_configuration ADD FOREIGN KEY (operator_set_id) REFERENCES project.operator_set (operator_set_id);

ALTER TABLE project.analysis_configuration ADD FOREIGN KEY (key_value_id) REFERENCES project.key_value_set (key_value_set_id);

ALTER TABLE project.analysis_configuration ADD FOREIGN KEY (base_id) REFERENCES project.base (base_id);

ALTER TABLE project.base_index ADD FOREIGN KEY (base_id) REFERENCES project.base (base_id);

ALTER TABLE project.operator_set_operator ADD FOREIGN KEY (operator_set_id) REFERENCES project.operator_set (operator_set_id);

ALTER TABLE project.operator_set_operator ADD FOREIGN KEY (operator_id) REFERENCES project.operator (operator_id);

ALTER TABLE project.key_value_set_values ADD FOREIGN KEY (key_value_set_id) REFERENCES project.key_value_set (key_value_set_id);

ALTER TABLE project.key_value_set_values ADD FOREIGN KEY (key_value_id) REFERENCES project.key_value (key_value_id);
