-- Copyright (c) 2013-2015 Snowplow Analytics Ltd. All rights reserved.
--
-- This program is licensed to you under the Apache License Version 2.0,
-- and you may not use this file except in compliance with the Apache License Version 2.0.
-- You may obtain a copy of the Apache License Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0.
--
-- Unless required by applicable law or agreed to in writing,
-- software distributed under the Apache License Version 2.0 is distributed on an
-- "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the Apache License Version 2.0 for the specific language governing permissions and limitations there under.
--
-- Authors: Yali Sassoon, Christophe Bogaert
-- Copyright: Copyright (c) 2013-2015 Snowplow Analytics Ltd
-- License: Apache License Version 2.0

-- We removed the in_progress table for sessions, because we can never guarantee all events related to a particular
-- session have reached the collector (some arrive weeks after the session finished - this is often related to offline
-- mobile usage). The sessions_new table will therefore have to be merged into the sessions pivot table.

-- First, combinate entires for visitors that occur in both tables.

INSERT INTO snowplow_pivots.sessions (
  SELECT
    n.blended_user_id,
    n.inferred_user_id,
    n.domain_userid,
    n.domain_sessionidx,
    n.etl_tstamp,
    o.session_start_tstamp,
    n.session_end_tstamp,
    n.event_count + o.event_count AS event_count,
    n.time_engaged_with_minutes + o.time_engaged_with_minutes AS time_engaged_with_minutes,
    o.geo_country,
    o.geo_country_code_2_characters,
    o.geo_country_code_3_characters,
    o.geo_region,
    o.geo_city,
    o.geo_zipcode,
    o.geo_latitude,
    o.geo_longitude,
    o.landing_page_host,
    o.landing_page_path,
    n.exit_page_host,
    n.exit_page_path,
    o.mkt_source,
    o.mkt_medium,
    o.mkt_term,
    o.mkt_content,
    o.mkt_campaign,
    o.refr_source,
    o.refr_medium,
    o.refr_term,
    o.refr_urlhost,
    o.refr_urlpath,
    o.br_name,
    o.br_family,
    o.br_version,
    o.br_type,
    o.br_renderengine,
    o.br_lang,
    o.br_features_director,
    o.br_features_flash,
    o.br_features_gears,
    o.br_features_java,
    o.br_features_pdf,
    o.br_features_quicktime,
    o.br_features_realplayer,
    o.br_features_silverlight,
    o.br_features_windowsmedia,
    o.br_cookies,
    o.os_name,
    o.os_family,
    o.os_manufacturer,
    o.os_timezone,
    o.dvce_type,
    o.dvce_ismobile,
    o.dvce_screenwidth,
    o.dvce_screenheight
  FROM snowplow_intermediary.sessions_new n
  INNER JOIN snowplow_intermediary.sessions_old o -- An INNER JOIN this time, restrict to sessions that have rows in both tables
  ON o.domain_userid = n.domain_userid AND o.domain_sessionidx = n.domain_sessionidx
);