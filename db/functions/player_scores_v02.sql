CREATE OR REPLACE FUNCTION public.player_scores(p_id bigint, mode_id integer)
 RETURNS TABLE(id integer, map character varying, mode integer, "time" integer, checkpoints integer[], speed_start double precision, speed_end double precision, speed_top double precision, speed_average double precision, date timestamp without time zone, rank bigint, total_records bigint)
 LANGUAGE plpgsql
AS $function$
BEGIN
	RETURN QUERY SELECT s.id, s.map, s.mode, s.time, s.checkpoints, s.speed_start,
	s.speed_end, s.speed_top, s.speed_average,
	s.updated_at AS date, (
	  SELECT (COUNT(*) + 1) FROM scores s_
	  WHERE s_.map = s.map AND s_.mode = s.mode AND (s_.time < s.time)
	) AS rank, (
	  SELECT COUNT(*) FROM scores s_
	  WHERE s_.map = s.map AND s_.mode = s.mode
	) AS total_records
FROM scores s
WHERE s.mode = mode_id AND s.player_id = p_id
ORDER BY map;
END; $function$
