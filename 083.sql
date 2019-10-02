/*Please add ; after each select statement*/
CREATE PROCEDURE battleshipGameResults()
BEGIN
    SELECT
      ddddd.size
    , SUM(ddddd.notouched) undamaged
    , SUM(ddddd.touched) partly_damaged
    , SUM(ddddd.sunk) sunk
    FROM (
        SELECT 
          dddd.id 
        , CASE WHEN dddd.size = dddd.hits THEN 1 ELSE 0 END sunk
        , CASE WHEN dddd.hits > 0 AND dddd.size != dddd.hits THEN 1 ELSE 0 END touched
        , CASE WHEN dddd.hits = 0 THEN 1 ELSE 0 END notouched
        , dddd.size
        FROM (
            SELECT
              ddd.id 
            , SUM(ddd.touched) hits
            , ddd.size
            FROM 
            (
                SELECT 
                dd.id 
                , dd.ids
                , CASE WHEN dd.tt = 1 OR dd.tt2 = 1 OR dd.tt3 = 1 OR dd.tt4 = 1 THEN 1 ELSE 0 END touched
                , dd.size
                FROM
                (
                    SELECT 
                    ops.id ids
                    , MBRContains(LineString(POINT(upper_left_x, upper_left_y), POINT(bottom_right_x, bottom_right_y)), POINT(target_x, target_y)) tt
                    , ST_Contains(LineString(POINT(upper_left_x, upper_left_y), POINT(bottom_right_x, bottom_right_y)), POINT(target_x, target_y)) tt2
                    , MBRTouches(LineString(POINT(upper_left_x, upper_left_y), POINT(bottom_right_x, bottom_right_y)), POINT(target_x, target_y)) tt3
                    , MBRWithin(LineString(POINT(upper_left_x, upper_left_y), POINT(bottom_right_x, bottom_right_y)), POINT(target_x, target_y)) tt4
                    , d.id
                    , d.size
                    FROM (
                        SELECT 
                          los.*
                        , (ST_Distance(POINT(upper_left_x, upper_left_y), POINT(bottom_right_x, bottom_right_y)) + 1) size 
                        FROM locations_of_ships los 
                    ) d, opponents_shots ops
                ) dd
                -- ORDER BY dd.id ASC, dd.ids ASC
            ) ddd
            GROUP BY ddd.id 
            -- ORDER BY ddd.size ASC
        ) dddd
    ) ddddd
    GROUP BY ddddd.size
    ORDER BY ddddd.size ASC
    ;
END