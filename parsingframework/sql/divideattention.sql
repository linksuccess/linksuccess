DROP TABLE IF EXISTS link_occurences;
CREATE TABLE link_occurences (id BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT, source_article_id BIGINT UNSIGNED, target_article_id BIGINT UNSIGNED, occ INT);
INSERT INTO link_occurences (source_article_id, target_article_id,occ) SELECT source_article_id, target_article_id, count(source_article_id) FROM link_features group by source_article_id, target_article_id;
ALTER TABLE link_occurences ADD INDEX (source_article_id);
ALTER TABLE link_occurences ADD INDEX (target_article_id);
ALTER TABLE link_occurences ADD INDEX (source_article_id, target_article_id);

UPDATE link_features l, link_occurences o
SET l.counts = l.counts/o.occ
WHERE l.counts IS NOT NULL AND l.source_article_id = o.source_article_id AND l.target_article_id = o.target_article_id;

CREATE TABLE semantic_similarity (id BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT, source_article_id BIGINT UNSIGNED, target_article_id BIGINT UNSIGNED, sim DOUBLE);
ALTER TABLE semantic_similarity ADD INDEX (source_article_id);
ALTER TABLE semantic_similarity ADD INDEX (target_article_id);
ALTER TABLE semantic_similarity ADD INDEX (source_article_id, target_article_id);