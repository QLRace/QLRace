CREATE OR REPLACE FUNCTION public.map_scores(map_name character varying, mode_id integer, scores_limit integer, scores_offset integer DEFAULT 0)
 RETURNS TABLE(rank bigint, id integer, mode integer, player_id bigint, name character varying, "time" integer, checkpoints integer[], speed_start double precision, speed_end double precision, speed_top double precision, speed_average double precision, date timestamp without time zone)
 LANGUAGE plpgsql
AS $function$
BEGIN
	RETURN QUERY SELECT rank() OVER (ORDER BY s.time),
		s.id, s.mode, s.player_id, p.name, s.time,
      	s.checkpoints, s.speed_start, s.speed_end, s.speed_top,
        s.speed_average, s.updated_at as date
	FROM scores s
	INNER JOIN players p
	ON s.player_id = p.id
	WHERE s.mode = mode_id AND s.map = map_name
	ORDER BY rank, date
	LIMIT scores_limit
	OFFSET scores_offset;
END; $function$