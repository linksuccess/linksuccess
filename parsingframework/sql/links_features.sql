CREATE TABLE link_features LIKE links;

ALTER TABLE `link_features`
DROP INDEX `source_article_id_2`,
DROP INDEX `target_article_id_2`,
DROP INDEX `target_article_id`,
DROP INDEX `source_article_id`,
DROP PRIMARY KEY,
ADD PRIMARY KEY (`id`);

ALTER TABLE link_features
ADD COLUMN counts DOUBLE,
ADD COLUMN source_article_in_degree INT,
ADD COLUMN source_article_out_degree INT,
ADD COLUMN source_article_degree INT,
ADD COLUMN source_article_page_rank DOUBLE,
ADD COLUMN source_article_local_clust DOUBLE,
ADD COLUMN source_article_eigen_centr DOUBLE,
ADD COLUMN source_article_kcore INT,
ADD COLUMN source_article_hits_authority DOUBLE,
ADD COLUMN source_article_hits_hub DOUBLE,
ADD COLUMN source_article_katz DOUBLE,
ADD COLUMN target_article_in_degree INT,
ADD COLUMN target_article_out_degree INT,
ADD COLUMN target_article_degree INT,
ADD COLUMN target_article_page_rank DOUBLE,
ADD COLUMN target_article_local_clust DOUBLE,
ADD COLUMN target_article_eigen_centr DOUBLE,
ADD COLUMN target_article_kcore INT,
ADD COLUMN target_article_hits_authority DOUBLE,
ADD COLUMN target_article_hits_hub DOUBLE,
ADD COLUMN target_article_katz DOUBLE,
ADD COLUMN rel_in_degree INT,
ADD COLUMN rel_out_degree INT,
ADD COLUMN rel_degree INT,
ADD COLUMN rel_page_rank DOUBLE,
ADD COLUMN rel_local_clust DOUBLE,
ADD COLUMN rel_eigen_centr DOUBLE,
ADD COLUMN rel_kcore INT,
ADD COLUMN rel_hits_authority DOUBLE,
ADD COLUMN rel_hits_hub DOUBLE,
ADD COLUMN rel_katz DOUBLE,
ADD COLUMN sem_similarity DOUBLE,
ADD COLUMN visual_region VARCHAR(32);

INSERT INTO link_features (source_article_id, target_article_id, target_position_in_text, target_position_in_text_only, target_position_in_section, target_position_in_section_in_text_only, section_name, section_number, target_position_in_table, table_number, table_css_class, table_css_style, target_x_coord_1920_1080, target_y_coord_1920_1080) SELECT source_article_id, target_article_id, target_position_in_text, target_position_in_text_only, target_position_in_section, target_position_in_section_in_text_only, section_name, section_number, target_position_in_table, table_number, table_css_class, table_css_style, target_x_coord_1920_1080, target_y_coord_1920_1080 FROM links;


ALTER TABLE link_features ADD INDEX (source_article_id);
ALTER TABLE link_features ADD INDEX (target_article_id);


CREATE TABLE mismatched_links AS (SELECT * FROM link_features w WHERE  NOT EXISTS (SELECT 1 FROM page_length aa WHERE aa.id=w.target_article_id));

ALTER TABLE mismatched_links ADD PRIMARY KEY (id);

DELETE FROM link_features WHERE id IN (SELECT id FROM mismatched_links);


UPDATE link_features AS c
INNER JOIN article_features AS a ON c.target_article_id = a.id
SET c.target_article_in_degree = a.in_degree, c.target_article_degree = a.degree, c.target_article_out_degree = a.out_degree, c.target_article_kcore=a.kcore, c.target_article_page_rank=a.page_rank, c.target_article_local_clust=a.local_clustering, c.target_article_eigen_centr = a.eigenvector_centr, c.target_article_hits_authority=a.hits_authority, c.target_article_hits_hub=a.hits_hub;

UPDATE link_features AS c
INNER JOIN article_features AS a ON c.source_article_id = a.id
SET c.source_article_in_degree = a.in_degree, c.source_article_degree = a.degree, c.source_article_out_degree = a.out_degree, c.source_article_kcore=a.kcore, c.source_article_page_rank=a.page_rank, c.source_article_local_clust=a.local_clustering, c.source_article_eigen_centr = a.eigenvector_centr, c.source_article_hits_authority=a.hits_authority, c.source_article_hits_hub=a.hits_hub;

UPDATE link_features
SET rel_in_degree = source_article_in_degree-target_article_in_degree, rel_degree = source_article_degree-target_article_degree, rel_out_degree = source_article_out_degree-target_article_out_degree, rel_kcore=source_article_kcore-target_article_kcore, rel_page_rank=source_article_page_rank-target_article_page_rank, rel_local_clust=source_article_local_clust-target_article_local_clust, rel_eigen_centr=source_article_eigen_centr-target_article_eigen_centr, rel_hits_authority=source_article_hits_authority-target_article_hits_authority, rel_hits_hub=source_article_hits_hub-target_article_hits_hub;


UPDATE link_features c, clickstream_derived t
SET c.counts=t.counts
WHERE c.source_article_id=t.prev_id AND c.target_article_id=t.curr_id;


UPDATE link_features
set visual_region = "lead"
WHERE section_number = 1;

UPDATE link_features
SET visual_region = "infobox"
WHERE  section_number = 1 AND table_css_class LIKE "%infobox%" OR table_css_class LIKE "%vertical%";

UPDATE link_features
SET visual_region = "navbox"
WHERE table_css_class LIKE "%nav%" AND table_css_class NOT LIKE "%infobox%" AND table_css_class NOT LIKE "%vertical%";

UPDATE link_features
SET visual_region = "body"
WHERE visual_region IS NULL;

UPDATE link_features
SET visual_region = "left-body"
WHERE visual_region="body" AND target_x_coord_1920_1080 < 200;

ALTER TABLE link_features ADD INDEX (source_article_id, target_article_id);


